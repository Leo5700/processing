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
    
    # saveFrame()
    # ffmpeg -r 24 -y -i "screen-%04d.tif" output.mkv
    # ffmpeg -r 24 -y -i 'screen-%04d.tif' -vb 20M output24.mkv

    # -r 24 -- это framerate 
    # "screen-%04d.tif" - screen-0001.tif
    # mkv понимает нестандартные размеры
    # -vb 20M -- это битрейт
    # https://habrahabr.ru/post/171213/
    # http://compizomania.blogspot.com/2014/05/ffmpeg-ubuntu-1404.html
    # http://stackoverflow.com/questions/3561715/using-ffmpeg-to-encode-a-high-quality-video
    
    

