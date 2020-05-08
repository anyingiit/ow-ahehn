globalvar test
globalvar test1

rule "init":
    @Condition test == 1
    @Event global
    test = 0
    test1 = 0
rule "switch problem":
    @Event global
    switch(test):
        case 0:
            pass
            break
        case 1:
            pass
            break
        case 2:
            pass
            break
        case 3:
            switch(test):
                case 0:
                    pass
                    break
                case 1:
                    pass
                    break