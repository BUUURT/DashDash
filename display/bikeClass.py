import time
from multiprocessing import Process


class Bike:
    def __init__(self,number):
        self.value=number
        self.laps = 0
        self.test=0
    def start(self):
        return str(time.time())

    def runner(self):
        while True:
            self.value = self.value+1
            print(str(self.value))
            time.sleep(0.1)


i = Bike(4)



#
#     def __str__(self):
#         return self.value
#     def __repr__(self):
#         return self.value
# def a():
#     i = 0
#     while True:
#         i +=1
#         print(i)
#
#
#
# def joy():
#     while True:
#         print('JOY')
#         time.sleep(1)
#
#
# if __name__ == '__main__':
#     i = Bike(6)
#     #p = Process(target=i.runner())
#     p =Process(target=a)
#     j = Process(target=joy)
#     p.start()
#     j.start()
