import time
import pickle
# class MyFile(object):
#     def __init__(self):
#         self.data = []
#     def write(self, stuff):
#         self.data.append(stuff)
#
# # class ExampleClass(object):
# #     def __init__(self, x):
# #         self.data = x
# # a = ExampleClass(123)
# a = 'meow'
# f = MyFile()
# pickle.dump(a, f)
from multiprocessing import Process

data = {'rpm':0,'speed':0}
lib = pickle.dumps(data)

def rpmGet():
    while True:
        i=str(time.time())
        newRpm = int(i.split('.')[1])*.0000001*13000
        i = pickle.loads(lib)
        i['rpm']=newRpm
        lib = pickle.dumps(lib)
        time.sleep(1)
        print(newRpm)


def reader():
    while True:
        val = pickle.loads(lib)
        print(val)



if __name__=="__main__":

    # rpmGet(lib)
    p1 = Process(target=rpmGet)
    p2 = Process(target=reader)
    #
    p1.start()
    p2.start()
    p1.join()
    p2.join()
