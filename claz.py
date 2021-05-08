
import matplotlib.pyplot as plt
from matplotlib.path import Path
import matplotlib.patches as patches
import threading
import time
import json

#
# with open('tracklist.json') as file:
#     data = json.load(file)
#
# s1 = data['tckc']['s1']
# s2 = data['tckc']['s2']
# s3 = data['tckc']['s3']
# area = Path(s3)
# area

# fig, ax = plt.subplots()
# patch = patches.PathPatch(area, facecolor='orange', lw=2)
# ax.add_patch(patch)
# ax.set_xlim(-119.3482044, -119.3459201)
# ax.set_ylim(46.3478294, 46.3499652)
# plt.show()



# areas = data['tckc']
# print(areas)
#
#
class Test:
    def __init__(self,elm):
        self.elm = elm
        # self.sure = lambda x :  int(self.elm)*x
        self.n=elm
        self.x = threading.Thread(target=self.bump)
        self.x.start()
        self.y = threading.Thread(target=self.top)
        self.y.start()
        # self.x.join()

    # def maths(self,elm):
    #     dat = len(elm)
    #     print(f'your len is {dat}')
    #     self.dat = dat
    def bump(self):
        while True:
            self.n+=1
            
    def top(self):
        while True:
            print("the answer is"+str(self.n))
            time.sleep(0.5)

    def layout(self):
        print (self.top()+"!!!")

i = Test(3)
