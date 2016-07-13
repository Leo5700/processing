'''
listening: Bohren & der Club of Gore -- Midnight Walker
'''


from wave import Wave

xoff = 0.0
yoff = 0.0

w1 = Wave(0.0, 100, 150)
w2 = Wave(1.2, 150, 150)
w3 = Wave(2.4, 200, 150)
w4 = Wave(3.6, 250, 150)

def setup():
    size(640, 360)
    

def draw():
    background(102)
    fill(0)
    frameRate(30)
    
    # global xoff
    # global yoff
    
    # xoff = 0
    # for x in range(0, width):
        # y = map(noise(xoff, yoff), 0, 1, 200, 300)
        # point(x, y)
        # xoff += 0.005
        
    # yoff += 0.02
    
    w1.display()
    w2.display()
    w3.display()
    w4.display()
