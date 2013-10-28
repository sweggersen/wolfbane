from urllib import urlencode
from urllib2 import urlopen, URLError, HTTPError


id = 4685
latitude = 63.626745
longitude = 11.351395

url = 'http://wolfbane.herokuapp.com/report'
form = urlencode((('sheep_id', id), ('latitude', latitude), ('longitude', longitude)))
print form
try:
    f = urlopen(url, form)
    print f.getcode()
    #print f.read()
except (URLError, HTTPError) as e:
    print e
