# 
# WolfBane sheepsim
# 
# 
# Use ctrl-c to input command
# Accepted commands:
# "q"               quit
# "alarm sheepID"   post alarm for specified sheep
# Or press enter to get back to posting positions
# 
# Reads sheep ID ranges from ranges.txt
# 
# ranges.txt should be of the form:
# from (and including) ID and to (and including) ID separated by -
# or single ID on separate lines
# Take care that ranges are sorted ascending and not overlapping
# Example:
# 1337-1350
# 4685
# 5000-5010
# 9999
# 


from time import sleep
from random import random
from urllib import urlencode
from urllib2 import urlopen, URLError, HTTPError
from threading import Thread


positions = {} #dictionary for previous position. ID as key, tuple of lat, long as value

#define global constants
#boundary box
MAX_LAT = 63.726403
MIN_LAT = 63.588291
MIN_LONG = 11.443253
MAX_LONG = 11.654429
#max lat or long variance per position update (0.01 = ~500m)
MAX_MOVE = 0.01
#center of area where sheep will be released
START_POS = (MAX_LAT - MAX_MOVE, MIN_LONG + MAX_MOVE)
#file to read sheep ID ranges from
INPUT_FILE = 'ranges.txt'



#calculate new position with random variance within boundaries
def newPosition(pos, minimum, maximum):
    newPos = 0
    while newPos < minimum or newPos > maximum: #redo if new position is outside boundary box
        newPos = pos + (MAX_MOVE - random() * MAX_MOVE * 2)
    return newPos


#do actual transmission of form data
def transmit(id, latitude, longitude, attack=0):
    url = 'http://localhost:3000/positions'
    #url = 'http://wolfbane.herokuapp.com/positions'
    form = urlencode((('position[sheep_id]', id), ('position[latitude]', latitude), ('position[longitude]', longitude), ('position[attacked]', attack)))
    try:
        f = urlopen(url, form)
        print "ID: " + str(id) + " HTTP return code: " + str(f.getcode())
    except (URLError, HTTPError) as e:
        print e


#send alarm for sheepID at last known position
def alarm(sheepID):
    latitude, longitude = positions.get(sheepID, START_POS)
    #transmit in separate thread to be independent of internet and server latency
    Thread(target=transmit, args=(sheepID, latitude, longitude, 1)).start()
    print "Alarm for sheep nr: " + str(sheepID)


#do per sheep
def sendPosition(sheepID):
    #get previous position or START_POS as default
    currentLat, currentLong = positions.get(sheepID, START_POS)
    
    #calculate new positions
    newLat = newPosition(currentLat, MIN_LAT, MAX_LAT)
    newLong = newPosition(currentLong, MIN_LONG, MAX_LONG)
    
    #store new position for next iteration
    positions[sheepID] = (newLat, newLong)
    #transmit in separate thread to be independent of internet and server latency
    Thread(target=transmit, args=(sheepID, newLat, newLong)).start()
    #set this as previous sheep
    global prevSheep
    prevSheep = sheepID
    
    print 'new position for sheep nr ' + str(sheepID) + ' is ' + "%.6f" % newLat + ', ' + "%.6f" % newLong
    sleep(SLEEP_TIME)
    #sleep(5)


#main program loop
def main():
    global prevSheep
    for item in ranges:
        #check for single sheep ID or range of ID's
        #and check if we hav aborted in the middle of a range
        if len(item) == 1 and item[0] > prevSheep:
            sendPosition(item[0])
            
        elif item[1] > prevSheep:
            n = item[1] - item[0] +1
            #iterate over ID range
            for i in range(prevSheep-item[0]+1, n):
                sendPosition(item[0]+i)
                
    prevSheep = ranges[0][0] - 1 #reset previous sheep


#initial setup of ranges array and sleep time
def init():
    print "\nWolfBane sheepsim 2014\n"

    #array of sheep ranges
    global ranges
    ranges = []
    n = 0 #total number of sheep
    #read from input file with ranges
    rangeFile = open(INPUT_FILE, 'r')
    for line in rangeFile:
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
    
    rangeFile.close()
    #set previous sheep to first sheep -1
    global prevSheep
    prevSheep = ranges[0][0] - 1
    
    #calculate time between updates based on total number of sheep
    global SLEEP_TIME
    SLEEP_TIME = 86400.0 / (n*3)

    print 'There are ' + str(n) + ' sheep to update'
    print 'Will sleep for ' + str(SLEEP_TIME) + 's between updates'
    for item in ranges:
        print item
    print
    
    loop()


#loop program for as long as needed. Use ctrl-c to input command
def loop():
    try:
        while True:
            main()
    except KeyboardInterrupt:
        command()
    

#read command from input
def command():
    print '\nInput command:\n"q" to quit\n"alarm sheepID" to post alarm\nEnter to continue running'
    cmd = raw_input().strip()
    
    if cmd == "":
        loop()
    elif cmd == "q":
        print '\nUser ended simulation'
    else:
        cmd = cmd.split()
        if cmd[0] == "alarm" and len(cmd) == 2 and isInt(cmd[1]):
            sheepID = int(cmd[1])
            alarm(sheepID)
            loop()
        else:
            print "error in input"
            command()


#check if a string is a number
def isInt(num):
    try:
        int(num)
        return True
    except ValueError:
        return False


init()
