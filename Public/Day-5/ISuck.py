
def rulecheck(self, rules, pages):
    for idx, page in reversed(list(enumerate(pages))):
        try:
            rule = rules[str(page)]
            for x in range(idx):
                if pages[x] in rule:
                        return 0
        except:
            continue

    middle = int((len(pages)-1)/2)
    return pages[middle]

def rulescan(self, rules, pages):
    for idx, page in reversed(list(enumerate(pages))):
        try:
            rule = rules[str(page)]
            for x in range(idx):
                if pages[x] in rule:
                        return self.rulefix(rules, pages)
        except:
            continue

    return 0

def rulefix(self, rules, pages):
    broken = True
    while broken:
        for idx, page in reversed(list(enumerate(pages))):
            try:
                rule = rules[str(page)]
                for x in range(idx):
                    if pages[x] in rule:
                            pages.append(pages.pop(x))
                            
            except:
                continue

        checker = self.rulecheck(rules, pages)
        if checker > 0:
            return checker


def build_data(self):
    rules = {}
    pages = []
    toggle = False
    for x in self.input:
        if x == "":
            toggle = True
            continue
        if not toggle:
            nums = x.split('|')
            nums[1] = int(nums[1])

            if nums[0] not in rules:
                rules[nums[0]] = [nums[1]]
            else:
                rules[nums[0]].append(nums[1])
        else:
            str_pages = x.split(',')
            pages.append([int(y) for y in str_pages])

    return rules, pages


# @answer(1234)
def part_1(self) -> int:
    count = 0
    rules, pages = self.build_data()

    for x in pages:
        count += self.rulecheck(rules, x)
        
    return(count)

# @answer(1234)
def part_2(self) -> int:
    count = 0
    rules, pages = self.build_data()

    for x in pages:
        count += self.rulescan(rules, x)
        print(count)

    return(count)

# @answer((1234, 4567))
# def solve(self) -> tuple[int, int]:
#     pass