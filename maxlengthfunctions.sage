import math
import time
import pandas as pd
from sage.combinat.posets.posets import FinitePoset



def SetAdd(L1, L2):
    L3 = []
    for a in L1:
        for b in L2:
            L3.append(a+b)
    L3 = list(set(L3))
    return L3



def ListByGensUpToE(A, E):
    List = []
    B = A
    while len(List) <= E:
        for b in B:
            List.append(b)
        B = SetAdd(A, B)
        List = list(set(List))
    return List



def LengthSetsUpToElement(S, nmax):
    gens = []
    for a in S:
        gens.append(a)
    lengthsets = {}
    lengthsets[0] = [0]
    for n in [1 .. nmax]:
        if n in lengthsets:
            continue
        lengthsets[n] = []
        for i in range(len(gens)):
            if n - gens[i] < 0:
                    continue
            lengthsets[n] += [l + 1 for l in lengthsets[n - gens[i]]]
        lengthsets[n] = sorted(list(Set(lengthsets[n])))
           
    return lengthsets



def PosetCreator(S, A):
    i = len(A) - 1
    j = len(A) - 1
    Dict = {}
    Array = []
    while i >= 0:
        Array = []
        j = len(A) - 1
        while j >= 0:
            if i == j:
                j -= 1
                continue
            if (A[j] - A[i]) in S: 
                Array.append(A[j])
            j -= 1
        Dict[A[i]] = Array
        i -= 1
    return Dict



def PosetCreatorMod(S, A):
    i = len(A) - 1
    j = len(A) - 1
    Dict = {}
    Dict2 = {}
    Array = []
    while i >= 0:
        Array = []
        j = len(A) - 1
        while j >= 0:
            if i == j:
                j -= 1
                continue
            if (A[j] - A[i]) in S: 
                Array.append(A[j])
            j -= 1
        Dict[A[i]] = Array
        i -= 1
    for a in A:
        Array2 = []
        for i in range(len(Dict[a])):
            Array2.append(Dict[a][i]%min(S.gens))
        Dict2[a%min(S.gens)] = Array2
    return Dict2



def PosetGraph(Dict):
    P = Poset(DiGraph(Dict), facade=False, cover_relations = False)
    return P.plot()



def MAp(S):
    Poset = []
    a = []
    b = 0
    for j in S.gens:
        a.append(j - min(S.gens))
        b += j - min(S.gens)
    print a
    b = b*max(S.gens)
    G = ListByGensUpToE(a, b)
    for u in range(0, min(S.gens)):
        for i in range (0, b): 
            if i in G:
                if i%min(S.gens) == u:
                    Poset.append(i)
                    break
    return Poset



def MApDict(S):
    Dict = {}
    a = []
    b = 0
    for j in S.gens:
        a.append(j - min(S.gens))
        b += j - min(S.gens)
    print a
    b = b*max(S.gens)
    G = ListByGensUpToE(a, b)
    for u in range(0, min(S.gens)):
        for i in range (0, b): 
            if i in G:
                if i%min(S.gens) == u:
                    Dict[u] = i
                    break
    return Dict



def MApPosetCreator(S):
    A = MAp(S)
    i = len(A) - 1
    j = len(A) - 1
    Dict = {}
    Array = []
    while i >= 0:
        Array = []
        j = len(A) - 1
        while j >= 0:
            if i == j:
                j -= 1
                continue
            if (A[j] - A[i]) in A: 
                Array.append(A[j])
            j -= 1
        Dict[A[i]] = Array
        i -= 1
    return Dict



def nMAp(S, n):
    MAp = []
    a = [0]
    for j in S:
        a.append(j)
    b = max(a)*max(a)
    G = ListByGensUpToE(a, b)
    for u in range(0, n):
        for i in range (0, b): 
            if i in G:
                if i%n == u:
                    MAp.append(i)
                    break
    return MAp



def nMApDict(S, n):
    MAp = {}
    a = [0]
    for j in S:
        a.append(j)
    b = max(a)*max(a)
    G = ListByGensUpToE(a, b)
    for u in range(0, n):
        for i in range (0, b): 
            if i in G:
                if i%n == u:
                    MAp[u] = i
                    break
    return MAp



def newMAp(S):
    Poset = []
    N = []
    for i in range(1, len(S.gens)):
        a = int(S.gens[i] - min(S.gens))
        N.append(a)
    Mp = MAp(S)
    j = max(Mp)
    Dict = LengthSetsUpToElement(N, j+1)
    for q in Mp:
        b = q + min(S.gens)*int(min(Dict[q]))
        Poset.append(b)
    return Poset



def PosetCreator2(S, A):
    i = len(A) - 1
    j = len(A) - 1
    Dict = {}
    Array = []
    while i >= 0:
        Array = []
        j = len(A) - 1
        while j >= 0:
            if i == j:
                j -= 1
                continue
            if (A[j] - A[i]) in A: 
                Array.append(A[j])
            j -= 1
        Dict[A[i]] = Array
        i -= 1
    return Dict



def secondMaxLength(S):
    startpoint = S.gens[0] * S.gens[len(S.gens) - 1] + max(S.BettiElements())
    S.LengthSetsUpToElement(startpoint + 100)
    M = []
    for a in range(startpoint, startpoint + 100):
        array = []
        arrb = S.LengthSet(a)[:]
        array.append(a)
        array.append(a%min(S.gens))
        array.append(arrb[len(arrb) - 1])
        array.append(arrb[len(arrb) - 2])
        array.append(arrb[len(arrb) - 1] - arrb[len(arrb) - 2])
        M.append(array)
    df = pd.DataFrame(M, index = None, columns=['n', 'mod n_1', 'Max Length', 'Second Highest', 'Difference'])
    return df




