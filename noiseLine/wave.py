class Wave:
    
    def __init__(self, yoff, xaxis, amp):
        
        self.yoff = yoff
        self.x = xaxis
        self.a = amp
        
    def display(self):
        
        xoff = 0
        for x in range(0, width):
            y = map(noise(xoff, self.yoff), 0, 1, self.x - self.a / 2, self.x + self.a / 2)
            point(x, y)
            xoff += 0.01
            
        self.yoff += 0.02
        
        filter(BLUR, 2);