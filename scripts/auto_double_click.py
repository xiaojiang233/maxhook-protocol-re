import ctypes
import threading
import time
import tkinter as tk

user32 = ctypes.windll.user32

INPUT_MOUSE = 0
MOUSEEVENTF_LEFTDOWN = 0x0002
MOUSEEVENTF_LEFTUP = 0x0004


class MOUSEINPUT(ctypes.Structure):
    _fields_ = [
        ("dx", ctypes.c_long),
        ("dy", ctypes.c_long),
        ("mouseData", ctypes.c_ulong),
        ("dwFlags", ctypes.c_ulong),
        ("time", ctypes.c_ulong),
        ("dwExtraInfo", ctypes.POINTER(ctypes.c_ulong)),
    ]


class INPUT(ctypes.Structure):
    class _INPUTUNION(ctypes.Union):
        _fields_ = [("mi", MOUSEINPUT)]

    _fields_ = [("type", ctypes.c_ulong), ("union", _INPUTUNION)]


def click_once():
    inp = INPUT()
    inp.type = INPUT_MOUSE
    inp.union.mi.dwFlags = MOUSEEVENTF_LEFTDOWN
    user32.SendInput(1, ctypes.byref(inp), ctypes.sizeof(INPUT))
    inp.union.mi.dwFlags = MOUSEEVENTF_LEFTUP
    user32.SendInput(1, ctypes.byref(inp), ctypes.sizeof(INPUT))


def double_click(gap=0.2):
    click_once()
    time.sleep(gap)
    click_once()


class AutoClicker:
    def __init__(self):
        self.running = False
        self.interval = 10.0
        self.click_gap = 0.2
        self.root = tk.Tk()
        self.root.title("Auto Double Click")
        self.root.attributes("-topmost", True)
        self.root.resizable(False, False)

        self.status = tk.Label(self.root, text="已停止", fg="gray")
        self.status.pack(padx=20, pady=(10, 5))

        btn = tk.Button(
            self.root,
            text="退出",
            width=10,
            command=self.on_exit,
            bg="#ff6666",
            fg="white",
        )
        btn.pack(padx=20, pady=(0, 10))

        self.root.protocol("WM_DELETE_WINDOW", self.on_exit)

    def on_exit(self):
        self.running = False
        self.root.destroy()

    def worker(self):
        while self.running:
            double_click(self.click_gap)
            time.sleep(self.interval)

    def start(self):
        self.running = True
        threading.Thread(target=self.worker, daemon=True).start()
        self.status.config(
            text=f"运行中：每 {self.interval:.0f} 秒双击", fg="green"
        )
        self.root.mainloop()


if __name__ == "__main__":
    AutoClicker().start()
