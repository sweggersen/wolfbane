from urllib import urlencode
from urllib2 import urlopen, URLError, HTTPError


id = 1
latitude = 63.726403
longitude = 11.443253
attack = 1

#url = 'http://wolfbane.herokuapp.com/positions'
url = 'http://localhost:3000/positions' #?sheep_id=2&latitude=63.726403&longitude=11.443253&attacked=1'
form = urlencode((('position[sheep_id]', id), ('position[latitude]', latitude), ('position[longitude]', longitude), ('position[attacked]', attack)))

print form
try:
    f = urlopen(url, form)
    print f.getcode()
    #print f.read()
except (URLError, HTTPError) as e:
    print e
