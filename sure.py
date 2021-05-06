def i(x):
    try:
        j = len(x)
    except type(x)==int:
        print('ints')
    return j
a = i(6)
b = i('hello')
c = i(None)

print(a)
print(b)
print(c)
