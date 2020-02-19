class Timer:
    def __init__(self,seed):
        self.i = seed
        while True:
            self.i += 1

        def __str__(self):
            return str(self.i)

        def __repr__(self):
            return str(self.i)
