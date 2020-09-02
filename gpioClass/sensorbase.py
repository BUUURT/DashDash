import time

class SensorBase(object):
    def __init__(self, update_callback):
        assert (update_callback is not None)

        self._cache_lifetime = 0
        self._last_updated = None
        self._update_callback = update_callback

    def _update(self, **kwargs):
        now = time.time()

        # If caching is disabled, just update the data.
        if self._cache_lifetime > 0:
            # Check if the cached value is still valid or not.
            if (self._last_updated is not None
                and self._last_updated + self._cache_lifetime > now):
                # The value is still valid.
                return

        # Get the latest sensor values.
        try:
            self._update_callback(**kwargs)
            self._last_updated = now
        except:
            raise

        return

    @property
    def cache_lifetime(self):
        '''Gets/Sets the cache time (in seconds).
        '''
        return (self._cache_lifetime)

    @cache_lifetime.setter
    def cache_lifetime(self, cache_lifetime):
        assert(cache_lifetime >= 0)

        self._cache_lifetime = cache_lifetime
