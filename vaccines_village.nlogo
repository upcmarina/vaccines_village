; VACCINES VILLAGE

; DONE BY Marina Vallejo Vallés

; SUPERVISED BY DR. Marta Ginovart Gisbert

globals [ number-dead]

villagers-own [ vaccine? infected? time-to-death ]   ;són els habitants del poble, els quals en un inici no estaven infectats
visitors-own [ vaccine? infected? arrival? time-to-death]  ;es tracta del viatger que arriba en avió


breed [houses house]
breed [plants plant]
breed [institutions institution]
breed [cars car]
breed [factories factory]
breed [planes plane]
breed [visitors visitor]
breed [villagers villager]

to setup
  clear-all
  ask patches [set pcolor pink + 4 ]
  draw-roads  ;crida a una subrutina

    create-houses 20 [
    set shape one-of [ "house bungalow" "house two story" "house ranch" ]
    set size 1.6
    move-to one-of patches with [ (pcolor = pink + 4) ]]

    create-institutions 3 [
    set shape one-of [ "building institution" ]
    set size 1.5
    set color pink + 2
    move-to one-of patches with [ (pcolor = pink + 4 ) ]]

    create-factories 4 [
    set shape one-of [ "factory" ]
    set size 1.8
    set color violet - 3
    move-to one-of patches with [  (pcolor = pink + 4) ]]

    create-plants 20  [
    set shape one-of [ "plant" "tree pine"]
    set size 0.8
    set color lime
    move-to one-of patches with [  (pcolor = pink + 4) ]]

    create-villagers people [   setxy random-xcor random-ycor set size 0.5
    set shape one-of [ "girl" "boy" ]
    set breed villagers
    set color green
    set time-to-death lifespan
    set vaccine? false
    set infected? false  ;la malaltia en el poble està erradicada, així que no pot haver cap infectat abans de l'arribada del viatger
    ]

    create-cars 10 [ set shape one-of [ "car" "truck"]
    set size 1
    set color magenta + 2
    move-to one-of patches with [ (pcolor = grey) ]]

    create-planes 1 [ set shape one-of [ "airplane" "airplane 2"]
    set size 4
    set color red + 1
    move-to one-of patches with [ (pcolor = pink + 4) and (pxcor = -14) and (pycor = 14)  ]]

    create-visitors 1 [
    set shape one-of  ["traveler"]
    set size 2.5
    set color red
    set time-to-death lifespan
    set arrival? false
    set vaccine? false
    set infected? true
    move-to one-of patches with [ (pcolor = pink + 4) and (pxcor = -15) and (pycor = 14)  ]]

    vaccines
    reset-ticks
end


to vaccines
  ask n-of ((people * vaccinated-percentage) / 100) villagers [set vaccine? true]
end

to draw-roads
  ask patches with [pycor mod 22 = 21 ] [
    set pcolor grey
    sprout 1 [
      set shape "road2"
      set color grey
      stamp die
    ]]

  ask patches with [pycor mod 22 = 0] [
    set pcolor grey
    sprout 1 [
      set shape "road2"
      set color grey
      stamp die
    ]]

  ask patches with [pycor mod 22 = 19 ] [
    set pcolor grey
    sprout 1 [
      set shape "road2"
      set color grey
      stamp die
  ]]


  ask patches with [pycor mod 22 = 18] [set pcolor grey sprout 1 [set shape "road2" set color grey stamp die]]

end


to go
 if ticks = 1000 [stop]
  move-cars
  move-planes
  move-visitor
  things-villagers
  tick
end

;a continuació es defineixen les subrutines

to move-cars
  ask cars [ set heading 90 fd 1 ]
end

to move-planes
  ask  planes [ facexy 1 3 lt 4 fd 1
                if (pxcor = 1) and (pycor = 3) [die]
               ]
end

to move-visitor
  ask visitors [ ifelse arrival?  [ rt random 100 lt random 100 fd 1 infect                                     ;s'executa en cas de que arribat? sigui TRUE
                                      if mortal? = TRUE [set time-to-death time-to-death - 1
                                      if time-to-death = 0 [ set number-dead  number-dead + 1  die ] ]]
                                  [ facexy 1 3 lt 4 fd 1 if (pxcor = 1) and (pycor = 3) [ set arrival? true ]    ; en cas de FALSE, només es farà 1 cop
                                  ]
               ]
  stop
end

to things-villagers
  ask villagers [ rt random 100 lt random 100 fd 1
    if infected? = TRUE [ infect
                          if mortal? = TRUE [ set time-to-death time-to-death - 1
                                               if time-to-death = 0 [ set number-dead  number-dead + 1  die ]
                                             ]
                        ]
                 ]
end

to infect
   ask other turtles-here with [breed = villagers and not vaccine? ]
        [
         if random-float 100 < 90 [ set infected? true   set color magenta - 1 ]
         ]
end
@#$#@#$#@
GRAPHICS-WINDOW
329
27
766
465
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
1
1
1
weeks
30.0

BUTTON
10
14
90
64
Set up
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
106
15
190
66
Go
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
201
15
310
66
Go forever
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
432
10
707
48
WELCOME TO VACCINES VILLAGE !
15
133.0
1

SLIDER
71
123
243
156
people
people
100
1000
800.0
50
1
NIL
HORIZONTAL

SLIDER
65
175
259
208
vaccinated-percentage
vaccinated-percentage
0
100
80.0
1
1
NIL
HORIZONTAL

SLIDER
136
229
308
262
lifespan
lifespan
50
200
100.0
10
1
NIL
HORIZONTAL

TEXTBOX
847
391
929
422
Only unvaccinated villagers that get the virus can die.
9
13.0
1

MONITOR
689
469
746
510
Deaths
number-dead
17
1
10

SWITCH
28
230
131
263
mortal?
mortal?
0
1
-1000

MONITOR
513
471
622
512
Infected Villagers
count villagers with [infected?]
17
1
10

MONITOR
346
471
459
512
Vaccinated Villagers
count villagers with [vaccine?]
17
1
10

TEXTBOX
955
392
1047
457
Only unvaccinated villagers can be infected
9
123.0
1

TEXTBOX
1084
386
1175
441
If an encounter with an infected agent is produced, the probability of being infected is 90 %
9
123.0
1

PLOT
804
81
1291
366
DISEASE EVOLUTION
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Total Population" 1.0 0 -16777216 true "" "plot count villagers"
"Women" 1.0 0 -4757638 true "" "plot count turtles with [ shape = \"girl\" ]"
"Men" 1.0 0 -12345184 true "" "plot count turtles with [ shape = \"boy\" ]"
"Infected" 1.0 0 -10022847 true "" "plot count villagers with [infected?] "
"Deaths" 1.0 0 -8053223 true "" "plot number-dead"

@#$#@#$#@
## WHAT IS IT?

This model tries to show the user the importance of population vaccination. It recreates the arrival of an infected visitor. That disease was already erradicated in the village but as the visitor was not vaccinated, he got the disease in another country and now is sick. Now he can infect those villagers that are not vaccinated. The user can change some of the values of the initial parameters and that will affect the dynamics. 

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES
Author: Marina Vallejo Vallés

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
false
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

airplane 2
false
0
Polygon -7500403 true true 150 26 135 30 120 60 120 90 18 105 15 135 120 150 120 165 135 210 135 225 150 285 165 225 165 210 180 165 180 150 285 135 282 105 180 90 180 60 165 30
Line -7500403 true 120 30 180 30
Polygon -7500403 true true 105 255 120 240 180 240 195 255 180 270 120 270

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

boy
false
10
Rectangle -7500403 true false 123 76 176 95
Polygon -13345367 true true 180 165 120 165 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Circle -7500403 true false 110 5 80
Circle -1 true false 152 143 9
Polygon -13345367 true true 105 42 111 16 128 2 149 0 178 6 190 18 192 28 220 29 216 34 201 39 167 35
Rectangle -7500403 true false 120 75 180 165
Rectangle -7500403 true false 90 90 120 90
Rectangle -7500403 true false 90 90 120 105
Rectangle -7500403 true false 90 105 120 120
Rectangle -7500403 true false 180 90 180 90
Rectangle -7500403 true false 180 90 210 120
Rectangle -7500403 true false 75 90 105 195
Rectangle -7500403 true false 195 90 225 195

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

building institution
false
0
Rectangle -7500403 true true 0 60 300 270
Rectangle -16777216 true false 130 196 168 256
Rectangle -16777216 false false 0 255 300 270
Polygon -7500403 true true 0 60 150 15 300 60
Polygon -16777216 false false 0 60 150 15 300 60
Circle -1 true false 135 26 30
Circle -16777216 false false 135 25 30
Rectangle -16777216 false false 0 60 300 75
Rectangle -16777216 false false 218 75 255 90
Rectangle -16777216 false false 218 240 255 255
Rectangle -16777216 false false 224 90 249 240
Rectangle -16777216 false false 45 75 82 90
Rectangle -16777216 false false 45 240 82 255
Rectangle -16777216 false false 51 90 76 240
Rectangle -16777216 false false 90 240 127 255
Rectangle -16777216 false false 90 75 127 90
Rectangle -16777216 false false 96 90 121 240
Rectangle -16777216 false false 179 90 204 240
Rectangle -16777216 false false 173 75 210 90
Rectangle -16777216 false false 173 240 210 255
Rectangle -16777216 false false 269 90 294 240
Rectangle -16777216 false false 263 75 300 90
Rectangle -16777216 false false 263 240 300 255
Rectangle -16777216 false false 0 240 37 255
Rectangle -16777216 false false 6 90 31 240
Rectangle -16777216 false false 0 75 37 90
Line -16777216 false 112 260 184 260
Line -16777216 false 105 265 196 265

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

factory
false
0
Rectangle -7500403 true true 76 194 285 270
Rectangle -7500403 true true 36 95 59 231
Rectangle -16777216 true false 90 210 270 240
Line -7500403 true 90 195 90 255
Line -7500403 true 120 195 120 255
Line -7500403 true 150 195 150 240
Line -7500403 true 180 195 180 255
Line -7500403 true 210 210 210 240
Line -7500403 true 240 210 240 240
Line -7500403 true 90 225 270 225
Circle -1 true false 37 73 32
Circle -1 true false 55 38 54
Circle -1 true false 96 21 42
Circle -1 true false 105 40 32
Circle -1 true false 129 19 42
Rectangle -7500403 true true 14 228 78 270

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

girl
false
11
Polygon -7500403 true false 120 90 120 195 120 300 105 300 135 300 150 225 165 300 195 300 180 300 180 195 180 90
Circle -7500403 true false 110 5 80
Rectangle -7500403 true false 127 79 172 94
Rectangle -7500403 true false 90 90 105 195
Rectangle -7500403 true false 195 90 210 195
Polygon -8630108 true true 120 180 75 255 210 255 225 255 180 180
Rectangle -7500403 true false 105 90 120 105
Rectangle -7500403 true false 180 90 195 105
Rectangle -1184463 true false 120 0 195 30
Rectangle -1184463 true false 105 0 120 90
Rectangle -1184463 true false 180 0 195 90
Rectangle -2674135 true false 135 60 165 75
Polygon -8630108 true true 120 90 120 180 180 180 180 90 165 90 165 120 135 120 135 90 120 90

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

house bungalow
false
0
Rectangle -7500403 true true 210 75 225 255
Rectangle -7500403 true true 90 135 210 255
Rectangle -16777216 true false 165 195 195 255
Line -16777216 false 210 135 210 255
Rectangle -16777216 true false 105 202 135 240
Polygon -7500403 true true 225 150 75 150 150 75
Line -16777216 false 75 150 225 150
Line -16777216 false 195 120 225 150
Polygon -16777216 false false 165 195 150 195 180 165 210 195
Rectangle -16777216 true false 135 105 165 135

house colonial
false
0
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 45 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 60 195 105 240
Rectangle -16777216 true false 60 150 105 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Polygon -7500403 true true 30 135 285 135 240 90 75 90
Line -16777216 false 30 135 285 135
Line -16777216 false 255 105 285 135
Line -7500403 true 154 195 154 255
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 135 150 180 180

house efficiency
false
0
Rectangle -7500403 true true 180 90 195 195
Rectangle -7500403 true true 90 165 210 255
Rectangle -16777216 true false 165 195 195 255
Rectangle -16777216 true false 105 202 135 240
Polygon -7500403 true true 225 165 75 165 150 90
Line -16777216 false 75 165 225 165

house ranch
false
0
Rectangle -7500403 true true 270 120 285 255
Rectangle -7500403 true true 15 180 270 255
Polygon -7500403 true true 0 180 300 180 240 135 60 135 0 180
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 45 195 105 240
Rectangle -16777216 true false 195 195 255 240
Line -7500403 true 75 195 75 240
Line -7500403 true 225 195 225 240
Line -16777216 false 270 180 270 255
Line -16777216 false 0 180 300 180

house two story
false
0
Polygon -7500403 true true 2 180 227 180 152 150 32 150
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 75 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 90 150 135 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Rectangle -7500403 true true 15 180 75 255
Polygon -7500403 true true 60 135 285 135 240 90 105 90
Line -16777216 false 75 135 75 180
Rectangle -16777216 true false 30 195 93 240
Line -16777216 false 60 135 285 135
Line -16777216 false 255 105 285 135
Line -16777216 false 0 180 75 180
Line -7500403 true 60 195 60 240
Line -7500403 true 154 195 154 255

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person business
false
0
Rectangle -1 true false 120 90 180 180
Polygon -13345367 true false 135 90 150 105 135 180 150 195 165 180 150 105 165 90
Polygon -7500403 true true 120 90 105 90 60 195 90 210 116 154 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 183 153 210 210 240 195 195 90 180 90 150 165
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 76 172 91
Line -16777216 false 172 90 161 94
Line -16777216 false 128 90 139 94
Polygon -13345367 true false 195 225 195 300 270 270 270 195
Rectangle -13791810 true false 180 225 195 300
Polygon -14835848 true false 180 226 195 226 270 196 255 196
Polygon -13345367 true false 209 202 209 216 244 202 243 188
Line -16777216 false 180 90 150 165
Line -16777216 false 120 90 150 165

person construction
false
0
Rectangle -7500403 true true 123 76 176 95
Polygon -1 true false 105 90 60 195 90 210 115 162 184 163 210 210 240 195 195 90
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Circle -7500403 true true 110 5 80
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -955883 true false 180 90 195 90 195 165 195 195 150 195 150 120 180 90
Polygon -955883 true false 120 90 105 90 105 165 105 195 150 195 150 120 120 90
Rectangle -16777216 true false 135 114 150 120
Rectangle -16777216 true false 135 144 150 150
Rectangle -16777216 true false 135 174 150 180
Polygon -955883 true false 105 42 111 16 128 2 149 0 178 6 190 18 192 28 220 29 216 34 201 39 167 35
Polygon -6459832 true false 54 253 54 238 219 73 227 78
Polygon -16777216 true false 15 285 15 255 30 225 45 225 75 255 75 270 45 285

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

realvisitors
false
10
Polygon -16777216 true false 120 90 105 90 60 195 90 210 116 154 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 183 153 210 210 240 195 195 90 180 90 150 165
Circle -16777216 true false 110 5 80
Rectangle -16777216 true false 127 76 172 91
Line -16777216 false 172 90 161 94
Line -16777216 false 128 90 139 94
Polygon -13345367 true true 195 225 195 300 270 270 270 195
Rectangle -13345367 true true 180 225 195 300
Polygon -13345367 true true 180 226 195 226 270 196 255 196
Polygon -13345367 true true 209 202 209 216 244 202 243 188
Line -16777216 false 180 90 150 165
Line -16777216 false 120 90 150 165
Rectangle -13345367 true true 120 0 180 15
Rectangle -13345367 true true 90 15 210 30
Circle -6459832 true false 120 30 0
Line -7500403 false 120 90 180 90
Rectangle -7500403 false false 120 90 180 105
Rectangle -16777216 true false 120 90 180 105
Rectangle -16777216 true false 120 105 180 165

road2
false
13
Rectangle -7500403 false false 0 120 300 180
Rectangle -7500403 true false 0 120 300 180
Rectangle -1 false false 15 150 30 150
Rectangle -7500403 true false 15 150 45 165
Rectangle -7500403 true false 0 120 300 195
Rectangle -1 true false 30 150 60 165
Rectangle -1 true false 105 150 135 165
Rectangle -1 true false 180 150 210 165
Rectangle -1 true false 255 150 285 165

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

traveler
false
10
Polygon -16777216 true false 120 90 105 90 60 195 90 210 116 154 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 183 153 210 210 240 195 195 90 180 90 150 165
Circle -16777216 true false 110 5 80
Rectangle -16777216 true false 127 76 172 91
Line -16777216 false 172 90 161 94
Line -16777216 false 128 90 139 94
Polygon -13345367 true true 195 225 195 300 270 270 270 195
Rectangle -13345367 true true 180 225 195 300
Polygon -13345367 true true 180 226 195 226 270 196 255 196
Polygon -13345367 true true 209 202 209 216 244 202 243 188
Line -16777216 false 180 90 150 165
Line -16777216 false 120 90 150 165
Rectangle -13345367 true true 120 0 180 15
Rectangle -13345367 true true 90 15 210 30
Circle -6459832 true false 120 30 0
Line -7500403 false 120 90 180 90
Rectangle -7500403 false false 120 90 180 105
Rectangle -16777216 true false 120 90 180 105
Rectangle -16777216 true false 120 105 180 165

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

tree pine
false
0
Rectangle -6459832 true false 120 225 180 300
Polygon -7500403 true true 150 240 240 270 150 135 60 270
Polygon -7500403 true true 150 75 75 210 150 195 225 210
Polygon -7500403 true true 150 7 90 157 150 142 210 157 150 7

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.3
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
