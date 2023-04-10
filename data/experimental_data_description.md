[This will continually be updated/replaced]
# Experimental Datasets
- **dev**
    - 701 entries
    - 20 cols: Trial_Nr, Trial_Id, Exp_Subject_Id, OptionChosen, TargetWord, knowledge, StemType, Frequency, AffixInitialSegment, Stem_romanization, Affix_romanization, Word_romanization, Tensification, Nasalization, L_deletion, C_deletion, Lateralization, UR, JunctureType, Production_R
- **train**
    - 2144 entries
    - 20 cols: Trial_Nr, Trial_Id, Exp_Subject_Id, OptionChosen, TargetWord, knowledge, StemType, Frequency, AffixInitialSegment, Stem_romanization, Affix_romanization, Word_romanization, Tensification, Nasalization, L_deletion, C_deletion, Lateralization, UR, JunctureType, Production_R
- **test_no_answers**
    - 1248 entries
    - 14 cols: Trial_Nr, Trial_Id, Exp_Subject_Id, OptionChosen, TargetWord, knowledge, StemType, Frequency, AffixInitialSegment, Stem_romanization, Affix_romanization, Word_romanization, UR, JunctureType
>(There is an earlier version of this dataset that includes production_R)


## Experimental Data: 'test_no_answers.csv'
### Categorical variables (10)
`targetWord`
- hangul version of verb + affix
- 180 levels:
```
갉나, 갉다, 갉아, 겊나, 겊다, 겊어, 겳나, 겳다, 겳어, 굵나, 굵다, 굵어, 긁나, 긁다, 긁어, 긆나, 긆다, 긆어, 낡나, 낡다, 낡아, 낣나, 낣다, 낣아, 냍나, 냍다, 냍어, 넓나, 넓다, 넓어, 눅나, 눅다, 눅어, 늙나, 늙다, 늙어, 덟나, 덟다, 덟어, 독나, 독다, 독아, 둡나, 둡다, 둡어, 듥나, 듥다, 듥어, 떫나, 떫다, 떫어, 막나, 막다, 막아, 맑나, 맑다, 맑아, 멁나, 멁다, 멁어, 묵나, 묵다, 묵어, 묽나, 묽다, 묽어, 박나, 박다, 박아, 밝나, 밝다, 밝아, 밟나, 밟다, 밟아, 뱉나, 뱉다, 뱉어, 법나, 법다, 법어, 붉나, 붉다, 붉어, 붍나, 붍다, 붍어, 뽑나, 뽑다, 뽑아, 속나, 속다, 속아, 숡나, 숡다, 숡어, 식나, 식다, 식어, 썩나, 썩다, 썩어, 씹나, 씹다, 씹어, 앍나, 앍다, 앍아, 얇나, 얇다, 얇아, 얕나, 얕다, 얕아, 얽나, 얽다, 얽어, 업나, 업다, 업어, 엎나, 엎다, 엎어, 엷나, 엷다, 엷어, 옅나, 옅다, 옅어, 웁나, 웁다, 웁어, 읊나, 읊다, 읊어, 익나, 익다, 익어, 읽나, 읽다, 읽어, 입나, 입다, 입어, 작나, 작다, 작아, 적나, 적다, 적어, 접나, 접다, 접어, 직나, 직다, 직어, 짉나, 짉다, 짉어, 집나, 집다, 집어, 짧나, 짧다, 짧아, 찍나, 찍다, 찍어, ,착나, 착다, 착아, 톱나, 톱다, 톱아, 핥나, 핥다, 핥아, 훑나, 훑다, 훑어
```

`Word_romanization`
- romanized version of verb + affix
- 180 levels
```
alka, alkna, alkta, caka, Caka, cakna, Cakna, cakta, Cakta, cikna, cikta, cikv, cilkna, cilkta, cilkv, cipna, cipta, cipv, cvkna, cvkta, cvkv, cvpna, cvpta, cvpv, dvlpna, dvlpta, dvlpv, halTa, halTna, halTta, hulTna, hulTta, hulTv, ikna, ikta, ikv, ilkna, ilkta, ilkv, ipna, ipta, ipv, Jalpa, Jalpna, Jalpta, Jikna, Jikta, Jikv, kalka, kalkna, kalkta, kjvlpna, kjvlpta, kjvlpv, kulkna,kulkta, kulkv, kvpna, kvPna, kvpta, kvPta, kvpv, kvPv, kxlkna, kxlkta, kxlkv, kxlPna, kxlPta, kxlPv, maka, makna, makta, malka, malkna, malkta, mukna, mukta, mukv, mulkna, mulkta, mulkv, mvlkna, mvlkta, mvlkv, nalka, nalkna, nalkta, nalpa, nalpna, nalpta, neTna, neTta, neTv, nukna, nukta, nukv, nvlpna, nvlpta, nvlpv, nxlkna, nxlkta, nxlkv, p*opa, p*opna, p*opta, paka, pakna, pakta, palka, palkna, palkta, palpa, palpna, palpta, peTna, peTta, peTv, pulkna, pulkta, pulkv, pulTna, pulTta, pulTv, s*ipna, s*ipta, s*ipv, s*vkna, s*vkta, s*vkv, sikna, sikta, sikv, soka, sokna, sokta, sulkna, sulkta, sulkv, toka, tokna, tokta, Topa, Topna, Topta, tupna, tupta, tupv, tvlpna, tvlpta, tvlpv, txlkna, txlkta, txlkv, upna, upta, upv, vlkna, vlkta, vlkv, vpna, vPna, vpta, vPta, vpv, vPv, xlPna, xlPta, xlPv, yalpa, yalpna, yalpta, yaTa, yaTna, yaTta, yvlpna, yvlpta, yvlpv, yvTna, yvTta, yvTv, 
```

`UR`
- segmental sequence surrounding the morpheme juncture (noted "-")
- 30 levels:
```
k-a, k-n, k-t, k-v, lk-a, lk-n, lk-t, lk-v, lp-n, lP-n, lp-t, lP-t, lp-v, lP-v, lT-a, lT-n, lT-t, lT-v, T-a, T-n, T-t, T-v, p-a, p-a, p-n, p-t, p-v, P-n, P-t, P-v
```

`JunctureType` 
- Type of stem and affix that were joined (see below for types)
- 6 levels:
*C+Obstruent, C+Sonorant, C+Vowel, lC+Obstruent, lC+Sonorant, lC+Vowel*

`StemType`
- 2 levels:
*-lc* or *-c* (simplex coda)

`Frequency`
- 3 levels:
*high, low, nonce*

`AffixInitialSegment`
- 3 levels:
*Obstruent, Sonorant, Vowel* 

`Stem_romanization`
- 64 levels:
```
alk , cak , Cak , cik , cilk , cip , cvk , cvp , dvlp , halT , hulT , ik , ilk , ip , Jalp , Jik , kalk , kjvlp , kulk , kvp , kvP , kxlk , kxlP , mak , malk , muk , mulk , mvlk , nalk , nalp , neT , nuk , nvlp , nxlk , p*op , pak , palk , palp , peT , pulk , pulT , s*ip , s*vk , sik , sok , sulk , tok , Top , tup , tvlp , txlk , up , vlk , vp , vP , xlP , yalp , yaT , yvlp , yvT 
```

`Affix_romanization`
- 4 levels:
*a-, na-, ta-, v-*


`OptionChosen` 
- 'production option that corresponds to the particular combination of tensificaton, nasalization, simplification, etc. for that particular wug form' 
(questions about whether this is true pending answer because this does not match up with the data)
- 6 levels

| level    | n   | percentage |
|----------|-----|------------|
| option_1 | 692 | 55.45      |
| option_3 | 146 | 11.7       |
| option_2 | 266 | 21.31      |
| option_4 | 129 | 10.34      |
| option_6 | 14  | 1.12       |
| option_5 | 1   | 0.08       |

#### Numerical variables (4)
`knowledge` 
- 5 levels:

| level | n   | percentage |
|-------|-----|------------|
| 1     | 343 | 27.48      |
| 2     | 66  | 5.29       |
| 3     | 17  | 1.36       |
| 4     | 57  | 4.57       |
| 5     | 765 | 61.30      | 

`Trial_Id`
- stem+affix combination for that trial
- range 1-180

`Trial_Nr`
- ‘linear trial order’ i.e. order of experimental items(?)stem+affix combination for that trial
- range 1-180

`Exp_Subject_Id`
- 7 levels:
559474, 559679, 567753, 569705, 579254, 580616, 584007
