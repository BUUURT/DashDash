import sensorbase
import spidev
import time

class Max6675(sensorbase.SensorBase):
    def __init__(self, bus = None, client = None):
        '''Initializes the sensor.
        bus: The SPI bus.
        client: The identifier of the client.
        '''
        assert(bus is not None)
        assert(client is not None)

        super(Max6675, self).__init__(self._update_sensor_data)

        self._bus = bus
        self._client = client

        self._temperature = None

        self._handle = spidev.SpiDev(self._bus, self._client)

    def __del__(self):
        if hasattr(self, '_handle'):
            self._handle.close()

    @property
    def temperature(self):
        '''Returns a temperature value.  Returns None if no valid value is
        set yet.
        '''
        self._update()
        return (self._temperature)

    def _update_sensor_data(self):
        vals = self._handle.readbytes(2)
        self._temperature = ((vals[0] << 8 | vals[1]) >> 3) * 0.25

if __name__ == '__main__':
    import spidev

    sensor = Max6675(0, 0)
    for cache in [0, 5]:
        print('**********')
        print('Cache lifetime is %d' % cache)
        sensor.cache_lifetime = cache
        for c in range(10):
            print(sensor.temperature)
