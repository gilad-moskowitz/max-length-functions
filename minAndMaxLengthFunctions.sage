load('/home/sage/NumericalSemigroup.sage')
import math

def AperySet(S, n, j = 1):
    if (j < 1):
        raise Exception("The j-th Apery set starts with j = 1.")
    jthSet = []
    for i in range(0, n):
        jCount = 0
        current = 0
        if(gcd(n, gcd(S.gens)) != 1):
            if(gcd(n, i) != gcd(S.gens)):
                if(0 not in jthSet):
                    jthSet.append(0)
                continue
        while(jCount < j):
            if((current in S) and (current%gcd(S.gens) == 0) and (current % n == i)):
                jCount += 1
                if(jCount == j):
                    break
            current += 1
        jthSet.append(current)
    return jthSet

def S_M(S):
    if (len(S.gens) < 2):
        raise Exception("There is no S_M for a semigroup with only one generator")
    S_M_gens = [S.gens[i]-S.gens[0] for i in range(1, len(S.gens))]
    return NumericalSemigroup(S_M_gens)

def S_m(S):
    if (len(S.gens) < 2):
        raise Exception("There is no S_m for a semigroup with only one generator")
    S_m_gens = [S.gens[len(S.gens) - 1]-S.gens[i] for i in range(0, len(S.gens) - 1)]
    return NumericalSemigroup(S_m_gens)

def b_ij(S, j = 1):
    return AperySet(S_M(S), min(S.gens), j)

def c_ij(S, j = 1):
    return AperySet(S_m(S), max(S.gens), j)

def jthMApSet(S, j = 1):
    return [i + min(S.gens)*min(S_M(S).LengthSet(i)) for i in AperySet(S_M(S), min(S.gens), j)]

def jth_mApSet(S, j = 1):
    return [max(S.gens)*min(S_m(S).LengthSet(i)) - i for i in AperySet(S_m(S), max(S.gens), j)]

def LengthSetPeriodicityBound(S):
    g = 0
    gPrime = 0
    gSmall = True
    gPrimeSmall = True
    bothDone = False
    while(not bothDone):
        j = 1
        while(gSmall):
            al = True
            for i in AperySet(S_M(S), min(S.gens), j):
                if(i < S_M(S).FrobeniusNumber()):
                    al = False
            if(al):
                g = int(j)
                gSmall = False
            else:
                j += 1
        j = 1
        while(gPrimeSmall):
            al = True
            for i in AperySet(S_m(S), max(S.gens), j):
                if(i < S_m(S).FrobeniusNumber()):
                    al = False
            if(al):
                gPrime = int(j)
                gPrimeSmall = False
            else:
                j += 1
        if(not gSmall and not gPrimeSmall):
            bothDone = True
    currentMax = 0
    for t in range(1, g+1):
        tempMax = max(jthMApSet(S, t))
        if(tempMax > currentMax):
            currentMax = int(tempMax)
        else:
            continue
    for r in range(1, gPrime+1):
        temp2Max = max(jth_mApSet(S, r))
        if(temp2Max > currentMax):
            currentMax = int(temp2Max)
        else:
            continue
    return currentMax

def jthMaxLength(S, n, j = 1):
    return ((n - b_ij(S, j)[n%min(S.gens)])/min(S.gens))

def jthMinLength(S, n, j = 1):
    return ((n + c_ij(S, j)[-(n%max(S.gens))])/max(S.gens))
