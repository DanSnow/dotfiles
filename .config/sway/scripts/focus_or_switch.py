#!/usr/bin/env python3
# encoding: utf-8

import subprocess
import json


def workspace_prev():
    subprocess.run(["i3-msg", "workspace", "prev"])


def focus_left():
    subprocess.run(["i3-msg", "focus", "left"])


def get_layout():
    res = subprocess.run(["i3-msg", "-t", "get_tree"], stdout=subprocess.PIPE)
    return json.loads(res.stdout.decode("utf-8"))


def find_focus_window(node, parent=None):
    node["parent"] = parent
    if node["focused"]:
        return node
    for n in node["nodes"]:
        res = find_focus_window(n, node)
        if res is not None:
            return res


def is_left_most_window(window):
    if window["type"] == "workspace":
        return True
    parent = window["parent"]
    orientation = parent["orientation"]
    if orientation == "horizontal" and window is not parent["nodes"][0]:
        return False
    return is_left_most_window(parent)


focus_window = find_focus_window(get_layout())
print(focus_window)

if is_left_most_window(focus_window):
    workspace_prev()
else:
    focus_left()
