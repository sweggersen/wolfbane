from sys import stdin
from time import sleep
from random import random


global sleepTime
global positions
global startPos
global maxLat
global minLat
global minLong
global maxLong
global maxMove


positions = {}
maxLat = 63.726403
minLat = 63.660369
minLong = 11.443253
maxLong = 11.536636
maxMove = 0.01 #~500 meter
startPos = (maxLat - maxMove, minLong + maxMove)


def newPosition(pos, minimum, maximum):
    newPos = 0
    while newPos < minimum or newPos > maximum:
        newPos = pos + (maxMove - random() * maxMove * 2)
    return newPos


def sendPosition(sheepID):
    currentLat, currentLong = positions.get(sheepID, startPos)
    
    newLat = newPosition(currentLat, minLat, maxLat)
    newLong = newPosition(currentLong, minLong, maxLong)
    
    positions[sheepID] = (newLat, newLong)
    
    print 'new position for sheep nr ' + str(sheepID) + ' is ' + "%.6f" % newLat + ', ' + "%.6f" % newLong
    #sleep(sleepTime)
    sleep(0.5)


def main(ranges):
    for item in ranges:
        if len(item) == 1:
            sendPosition(item[0])
        else:
            n = item[1] - item[0] +1
            for i in range(n):
                sendPosition(item[0]+i)


def init():
    print "\nWolfBane sheepsim 2014\n"

    ranges = []
    n = 0
    for line in stdin:
        temp = line.strip().split('-')
        if len(temp) == 1:
            temp[0] = int(temp[0])
            n += 1
        else:
            temp[0] = int(temp[0])
            temp[1] = int(temp[1])
            n += temp[1] - temp[0] +1

        ranges.append(temp)

    global sleepTime
    sleepTime = 86400.0 / (n*3)

    print 'There are ' + str(n) + ' sheep to update'
    print 'Will sleep for ' + str(sleepTime) + 's between updates'
    for item in ranges:
        print item
    print

    while True:
        main(ranges)




init()
