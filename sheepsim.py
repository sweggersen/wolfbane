# 
# WolfBane sheepsim
# 
# Provide txt file with ranges to stdin
# Example command: python sheepsim.py < ranges.txt
# 
# txt file should be of the form:
# from (and including) ID and to (and including) ID separated by -
# or single ID on separate lines
# Example:
# 1337-1350
# 4685
# 5000-5010
# 9999
# 


from sys import stdin
from time import sleep
from random import random
from urllib import urlencode
from urllib2 import urlopen, URLError, HTTPError


positions = {} #dictionary for previous position. ID as key, tuple of lat, long as value

#define global constants
#boundary box
MAX_LAT = 63.726403
MIN_LAT = 63.660369
MIN_LONG = 11.443253
MAX_LONG = 11.536636
#max lat or long variance per position update (0.01 = ~500m)
MAX_MOVE = 0.01
#center of area where sheep will be released
START_POS = (MAX_LAT - MAX_MOVE, MIN_LONG + MAX_MOVE)



#calculate new position with random variance within boundary box
def newPosition(pos, minimum, maximum):
    newPos = 0
    while newPos < minimum or newPos > maximum: #redo if new position is outside boundary box
        newPos = pos + (MAX_MOVE - random() * MAX_MOVE * 2)
    return newPos


#do actual transmission of form data
def transmit(id, latitude, longitude):
    url = 'http://wolfbane.herokuapp.com/post'
    form = urlencode((('id', id), ('lat', latitude), ('long', longitude)))
    try:
        f = urlopen(url, form)
        print f.getcode()
        #print f.read()
    except (URLError, HTTPError) as e:
        print e


#do per sheep
def sendPosition(sheepID):
    #get previous position or START_POS as default
    currentLat, currentLong = positions.get(sheepID, START_POS)
    
    #calculate new positions
    newLat = newPosition(currentLat, MIN_LAT, MAX_LAT)
    newLong = newPosition(currentLong, MIN_LONG, MAX_LONG)
    
    #store new position for next iteration
    positions[sheepID] = (newLat, newLong)
    #transmit(sheepID, newLat, newLong)
    
    print 'new position for sheep nr ' + str(sheepID) + ' is ' + "%.6f" % newLat + ', ' + "%.6f" % newLong
    #sleep(SLEEP_TIME)
    sleep(0.5)


#main program loop
def main(ranges):
    for item in ranges:
        #check for single sheep ID or range of ID's
        if len(item) == 1:
            sendPosition(item[0])
        else:
            n = item[1] - item[0] +1
            #iterate over ID range
            for i in range(n):
                sendPosition(item[0]+i)


#initial setup
def init():
    print "\nWolfBane sheepsim 2014\n"

    ranges = [] #array of sheep ranges
    n = 0 #total number of sheep
    #read from input file (provided to stdin). Example command: python sheepsim.py < ranges.txt
    for line in stdin:
        temp = line.strip().split('-')
        #check for single sheep ID or range of ID's
        if len(temp) == 1:
            temp[0] = int(temp[0])
            n += 1
        else:
            temp[0] = int(temp[0])
            temp[1] = int(temp[1])
            n += temp[1] - temp[0] +1

        ranges.append(temp)

    #calculate time between updates based on total number of sheep
    global SLEEP_TIME
    SLEEP_TIME = 86400.0 / (n*3)

    print 'There are ' + str(n) + ' sheep to update'
    print 'Will sleep for ' + str(SLEEP_TIME) + 's between updates'
    for item in ranges:
        print item
    print

    #loop program for as long as needed. Use ctrl-c to abort
    while True:
        main(ranges)



try:
    init()
except KeyboardInterrupt:
    print '\nUser ended simulation'
