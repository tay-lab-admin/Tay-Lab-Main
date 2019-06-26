import math
from zaber.serial import AsciiDevice, AsciiSerial, AsciiCommand
from pynput.keyboard import Key, Listener, KeyCode



class Printer:
    def __init__(self):
        self.micronsPerStep = 0.124023437

        self.xAddress = 2
        self.yAddress = 1
        self.zAddress = 3

        self.portName = "COM3"

        self.serialPort = AsciiSerial(self.portName)

        self.xDevice = AsciiDevice(self.serialPort, self.xAddress)
        self.yDevice = AsciiDevice(self.serialPort, self.yAddress)
        self.zDevice = AsciiDevice(self.serialPort, self.zAddress)

        self.moveSpeed = 20000

    def IsBusy(self):
        return self.xDevice.get_status() == "BUSY" or self.yDevice.get_status() == "BUSY" or self.zDevice.get_status() == "BUSY"

    def Home(self):
        print("Homing...\n")

        self.serialPort.write(AsciiCommand("home"))
        self.serialPort.read()
        self.serialPort.read()
        self.serialPort.read()
        while self.IsBusy():
            pass

        print("Done.\n")

    def PromptBounds(self):
        printer.zDevice.send("move max")

        print("Move the print head to the top-left corner of the print area\n")
        self.GiveKeyControl()
        self.left = self.xDevice.get_position()
        self.top = self.yDevice.get_position()

        print("Move the print head to the bottom-right corner of the print area\n")
        self.GiveKeyControl()
        self.right = self.xDevice.get_position()
        self.bottom = self.yDevice.get_position()

        printer.zDevice.send("move max")
        self.MoveToCenter()

        print("Move the print head to the working height.")
        self.GiveKeyControl(x = False, y = False)
        self.printPoint = self.zDevice.get_position()

    def MoveToCenter(self):
        print("Centering...")

        center = ((self.left+self.right)/2, (self.top+self.bottom)/2)

        self.xDevice.move_abs(int(center[0]), blocking=False)
        self.yDevice.move_abs(int(center[1]), blocking=False)

        while(self.IsBusy()):
            pass

        print("Done.")

    def SafeMove(self, device, speed):
        if self.movingList[device] == True or self.enableList[device] == False:
            return
        else:
            device.move_vel(speed)
            self.movingList[device] = True

    def SafeStop(self, device):
        self.movingList[device] = False
        device.stop()

    def on_press(self, key):
        if key == Key.up:
            self.SafeMove(self.zDevice, -self.moveSpeed)
        if key == Key.down:
            self.SafeMove(self.zDevice, self.moveSpeed)
        if key == KeyCode(char='w'):
            self.SafeMove(self.yDevice, self.moveSpeed)
        if key == KeyCode(char='s'):
            self.SafeMove(self.yDevice, -self.moveSpeed)
        if key == KeyCode(char='a'):
            self.SafeMove(self.xDevice, self.moveSpeed)
        if key == KeyCode(char='d'):
            self.SafeMove(self.xDevice, -self.moveSpeed)

    def on_release(self, key):
        if key == Key.enter:
            # Stop listener
            return False
        
        if key == Key.up or key == Key.down:
            self.SafeStop(self.zDevice)
        if key == KeyCode(char='w') or key == KeyCode(char='s'):
            self.SafeStop(self.yDevice)
        if key == KeyCode(char='a') or key == KeyCode(char='d'):
            self.SafeStop(self.xDevice)

        change = False
        if key == KeyCode(char='+') or key == KeyCode(char='='):
            self.moveSpeed *= 2
            change = True
        if key == KeyCode(char='-') or key == KeyCode(char='_'):
            self.moveSpeed = math.ceil(self.moveSpeed/2)
            change = True

        if change:
            print("New movement speed: " + str(self.moveSpeed * self.micronsPerStep * 0.0001) + " centimeters per second.")
            self.SafeStop(self.xDevice)
            self.SafeStop(self.yDevice)
            self.SafeStop(self.zDevice)

    def GiveKeyControl(self, x = True, y = True, z = True):
        self.movingList = {}
        self.SafeStop(self.xDevice)
        self.SafeStop(self.yDevice)
        self.SafeStop(self.zDevice)

        self.enableList = {self.xDevice: x, self.yDevice: y, self.zDevice: z}

        xString = "Move X with A-D. " 
        yString = "Move Y with W-S. " 
        zString = "Move Z with the up and down arrow keys. " 

        string = "("

        if x:
            string += xString
        if y:
            string += yString
        if z:
            string += zString

        string += "Change speed with +/-. Press ENTER to finish.)\n"
        print(string)
        # Collect events until released
        with Listener(
                on_press=lambda key: self.on_press(key),
                on_release=lambda key: self.on_release(key), suppress=True) as listener:
            listener.join()

printer = Printer()
printer.PromptBounds()