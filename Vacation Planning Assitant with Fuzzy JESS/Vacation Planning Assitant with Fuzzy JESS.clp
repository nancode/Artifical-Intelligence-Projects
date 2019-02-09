;Vacation planning assistant using fuzzy logic.
(clear)
(reset)

(import nrc.fuzzy.*)
(import nrc.fuzzy.jess.*)

;defines all the global variables.
;4 parameters are got from the user. 

;Budget per person is expected to take value from $0-$1000
(defglobal ?*budget* 
    = (new nrc.fuzzy.FuzzyVariable "budget" 0.0 1000.0 "Dollars"))

;Distance that the user is willing to travel is assumed to be between 0 - 1000 miles.
(defglobal ?*distance* 
    = (new nrc.fuzzy.FuzzyVariable "distance" 0.0 1000.0 "Miles"))

;The number of days is assumed to be between 1-20 days
(defglobal ?*days* 
    = (new nrc.fuzzy.FuzzyVariable "days" 1.0 20.0 "Days"))

;The type of accommodation is either an airbnb or a star hotel. The rating is assumed.
(defglobal ?*accomodation* 
    = (new nrc.fuzzy.FuzzyVariable "accomodation" 0.0 10.0 "Kind of accomodation"))

; These are fuzzy parameters that are used to map the user requirements to the avaialable recommendation.
(defglobal ?*distancesmallbudget* 
    = (new nrc.fuzzy.FuzzyVariable "recommendation1" 1.0 10.0 ""))

(defglobal ?*distancelargebudget* 
    = (new nrc.fuzzy.FuzzyVariable "recommendation2" 1.0 10.0 ""))

(defglobal ?*dayssmallbudget* 
    = (new nrc.fuzzy.FuzzyVariable "recommendation3" 1.0 10.0 ""))

(defglobal ?*dayslargebudget* 
    = (new nrc.fuzzy.FuzzyVariable "recommendation4" 1.0 10.0 ""))

(defglobal ?*accomodationsmallbudget* 
    = (new nrc.fuzzy.FuzzyVariable "recommendation5" 1.0 10.0 ""))

(defglobal ?*accomodationlargebudget* 
    = (new nrc.fuzzy.FuzzyVariable "recommendation6" 1.0 10.0 ""))

(defglobal ?*leastsmallbudget* 
    = (new nrc.fuzzy.FuzzyVariable "recommendation7" 1.0 10.0 ""))

(defglobal ?*bestsmallbudget* 
    = (new nrc.fuzzy.FuzzyVariable "recommendation8" 1.0 10.0 ""))

(defglobal ?*leastlargebudget* 
    = (new nrc.fuzzy.FuzzyVariable "recommendation9" 1.0 10.0 ""))

(defglobal ?*bestlargebudget* 
    = (new nrc.fuzzy.FuzzyVariable "recommendation10" 1.0 10.0 ""))

;delete or add more suggestions here

;Initaite all the variables with possible values for the fuzzy variables.
(defrule initiateFuzzy
    =>
    (load-package nrc.fuzzy.jess.FuzzyFunctions)
    
    (?*accomodation* addTerm "cheap" (create$ 0.0 5.0) (create$ 1.0 0.0) 2)
    (?*accomodation* addTerm "costly" (create$ 5.0 10.0) (create$ 0.0 1.0) 2)
    
    (?*distance* addTerm "near" (create$ 0.0 200.0) (create$ 1.0 0.0) 2)
    (?*distance* addTerm "far" (create$ 600.0 1000.0) (create$ 0.0 1.0) 2)
    
    (?*days* addTerm "few" (create$ 1.0 5.0) (create$ 1.0 0.0) 2)
    (?*days* addTerm "many" (create$ 5.0 20.0) (create$ 0.0 1.0) 2)
    
    (?*budget* addTerm "small" (create$ 0.0 350.0) (create$ 1.0 0.0) 2)
    (?*budget* addTerm "large" (create$  351.0  1000.00) (create$ 0.0 1.0) 2)
    
    (?*dayssmallbudget* addTerm "fewdays" (create$ 1 5.0) (create$ 1.0 0.0) 2)
    (?*dayssmallbudget* addTerm "manydays" (create$ 5.0 10.0) (create$ 0.0 1.0) 2)
    
    (?*dayslargebudget* addTerm "fewdays" (create$ 1 2.5) (create$ 1.0 0.0) 2)
    (?*dayslargebudget* addTerm "manydays" (create$ 5.0 10.0) (create$ 0.0 1.0) 2)
    
    (?*distancesmallbudget* addTerm "neardistance" (create$ 1 5.0)  (create$ 1.0 0.0) 2)
    (?*distancesmallbudget* addTerm "fardistance" (create$ 5.0 10.0) (create$ 0.0 1.0) 2)
    
    (?*distancelargebudget* addTerm "neardistance" (create$ 1 5.0)  (create$ 1.0 0.0) 2)
    (?*distancelargebudget* addTerm "fardistance" (create$ 5.0 10.0) (create$ 0.0 1.0) 2)
    
    (?*accomodationsmallbudget* addTerm "cheapaccomodation" (create$ 1 5.0)  (create$ 1.0 0.0) 2)
    (?*accomodationsmallbudget* addTerm "costlyaccomodation" (create$ 5.0 10.0) (create$ 0.0 1.0) 2)
    
    (?*accomodationlargebudget* addTerm "cheapaccomodation" (create$ 1 5.0)  (create$ 1.0 0.0) 2)
    (?*accomodationlargebudget* addTerm "costlyaccomodation" (create$ 5.0 10.0) (create$ 0.0 1.0) 2)
    
    (?*leastlargebudget* addTerm "leastavailable" (create$ 1 5.0)  (create$ 1.0 0.0) 2)
    (?*bestlargebudget* addTerm "bestavailable" (create$ 5.0 10.0) (create$ 0.0 1.0) 2)
    
    (assert (initiationDone))
    )

;Read the values submitted
(defrule readValue
    (initiationDone)
    =>
    (printout t "May I know your name?")
    (bind ?name (readline))
    (printout t crlf )
    (printout t "*******************************************************************************" crlf )
    (printout t "Hello, "?name ". I'm your Vacation Planning Assistant. "crlf)
    (printout t "I can help you decide on your next vacation spot." crlf)
    (printout t "Please answer the following questions with one of the options given in the []." crlf)
    (printout t "*******************************************************************************" crlf )
    
    (printout t crlf "For how many days are you planning to go? [few | many]" crlf)
    (bind ?y (readline))
    (assert (days (new nrc.fuzzy.FuzzyValue ?*days* ?y)))
    
    (printout t "Let's talk about money.Which word best describes your budget? [small | large]" crlf)
    (bind ?b (readline))
    (assert (budget (new nrc.fuzzy.FuzzyValue ?*budget* ?b)))
    
    (printout t "How much do you want to travel? [near | far]" crlf)
    (bind ?s (readline))
    (assert (distance (new nrc.fuzzy.FuzzyValue ?*distance* ?s)))
    
    (printout t "what kind of accomodation would you prefer? [cheap | costly]:" crlf)
    (bind ?a (readline))
    (assert (accomodation (new nrc.fuzzy.FuzzyValue ?*accomodation* ?a)))
    
    (printout t "I would suggest you to go to," crlf))

;Define all the rules for the different combinations and once the rule is fired, the recommendation is analysed.

(defrule rule1(budget ?b&:(fuzzy-match ?b "small"))(distance ?s&:(fuzzy-match ?s "near"))(days ?y&:(fuzzy-match ?y "few"))(accomodation ?a&:(fuzzy-match ?a "cheap"))
    =>(assert (recommendation7 (new nrc.fuzzy.FuzzyValue ?*leastsmallbudget* "leastavaialable"))))

(defrule rule2(budget ?b&:(fuzzy-match ?b "small"))(distance ?s&:(fuzzy-match ?s "near"))(days ?y&:(fuzzy-match ?y "few"))(accomodation ?a&:(fuzzy-match ?a "costly"))
    =>(assert (recommendation5 (new nrc.fuzzy.FuzzyValue ?*accomodationsmallbudget* "costlyaccomodation"))))

(defrule rule3(budget ?b&:(fuzzy-match ?b "small"))(distance ?s&:(fuzzy-match ?s "near"))(days ?y&:(fuzzy-match ?y "many"))(accomodation ?a&:(fuzzy-match ?a "cheap"))
    =>(assert (recommendation3 (new nrc.fuzzy.FuzzyValue ?*dayssmallbudget* "manydays"))))

(defrule rule4(budget ?b&:(fuzzy-match ?b "small"))(distance ?s&:(fuzzy-match ?s "near"))(days ?y&:(fuzzy-match ?y "many"))(accomodation ?a&:(fuzzy-match ?a "costly")) 
    =>(assert (recommendation1 (new nrc.fuzzy.FuzzyValue ?*distancesmallbudget* "neardistance"))))

(defrule rule5 (budget ?b&:(fuzzy-match ?b "small"))(distance ?s&:(fuzzy-match ?s "far"))(days ?y&:(fuzzy-match ?y "few"))(accomodation ?a&:(fuzzy-match ?a "cheap"))
   =>(assert (recommendation1 (new nrc.fuzzy.FuzzyValue ?*distancesmallbudget* "fardistance"))))

(defrule rule6(budget ?b&:(fuzzy-match ?b "small"))(distance ?s&:(fuzzy-match ?s "far"))(days ?y&:(fuzzy-match ?y "few"))(accomodation ?a&:(fuzzy-match ?a "costly"))
    =>(assert (recommendation3 (new nrc.fuzzy.FuzzyValue ?*dayssmallbudget* "fewdays"))))

(defrule rule7(budget ?b&:(fuzzy-match ?b "small"))(distance ?s&:(fuzzy-match ?s "far"))(days ?y&:(fuzzy-match ?y "many"))(accomodation ?a&:(fuzzy-match ?a "cheap"))
    =>(assert (recommendation5 (new nrc.fuzzy.FuzzyValue ?*accomodationsmallbudget* "cheapaccomodation"))))

(defrule rule8(budget ?b&:(fuzzy-match ?b "small"))(distance ?s&:(fuzzy-match ?s "far"))(days ?y&:(fuzzy-match ?y "many"))(accomodation ?a&:(fuzzy-match ?a "costly"))
    =>(assert (recommendation5 (new nrc.fuzzy.FuzzyValue ?*accomodationsmallbudget* "costlyaccomodation")))
    )
(defrule rule9(budget ?b&:(fuzzy-match ?b "large"))(distance ?s&:(fuzzy-match ?s "near"))(days ?y&:(fuzzy-match ?y "few"))(accomodation ?a&:(fuzzy-match ?a "cheap"))
   =>(assert (recommendation9 (new nrc.fuzzy.FuzzyValue ?*leastlargebudget* "leastavailable"))) )

(defrule rule10 (budget ?b&:(fuzzy-match ?b "large"))(distance ?s&:(fuzzy-match ?s "near"))(days ?y&:(fuzzy-match ?y "few"))(accomodation ?a&:(fuzzy-match ?a "costly"))
   =>(assert (recommendation6 (new nrc.fuzzy.FuzzyValue ?*accomodationlargebudget* "costlyaccomodation"))))

(defrule rule11(budget ?b&:(fuzzy-match ?b "large"))(distance ?s&:(fuzzy-match ?s "near"))(days ?y&:(fuzzy-match ?y "many"))(accomodation ?a&:(fuzzy-match ?a "cheap"))=>
    (assert (recommendation4 (new nrc.fuzzy.FuzzyValue ?*dayslargebudget* "manydays"))))

(defrule rule12(budget ?b&:(fuzzy-match ?b "large"))(distance ?s&:(fuzzy-match ?s "near"))(days ?y&:(fuzzy-match ?y "many"))(accomodation ?a&:(fuzzy-match ?a "costly"))
   => (assert (recommendation2 (new nrc.fuzzy.FuzzyValue ?*distancelargebudget* "neardistance"))))

(defrule rule13(budget ?b&:(fuzzy-match ?b "large"))(distance ?s&:(fuzzy-match ?s "far"))(days ?y&:(fuzzy-match ?y "few"))(accomodation ?a&:(fuzzy-match ?a "cheap"))
    =>(assert (recommendation2 (new nrc.fuzzy.FuzzyValue ?*distancelargebudget* "fardistance"))))

(defrule rule14(budget ?b&:(fuzzy-match ?b "large"))(distance ?s&:(fuzzy-match ?s "far"))(days ?y&:(fuzzy-match ?y "few"))(accomodation ?a&:(fuzzy-match ?a "costly"))
     =>(assert (recommendation4 (new nrc.fuzzy.FuzzyValue ?*dayslargebudget* "fewdays"))))

(defrule rule15(budget ?b&:(fuzzy-match ?b "large"))(distance ?s&:(fuzzy-match ?s "far"))(days ?y&:(fuzzy-match ?y "many"))(accomodation ?a&:(fuzzy-match ?a "cheap"))
     =>(assert (recommendation6 (new nrc.fuzzy.FuzzyValue ?*accomodationlargebudget* "cheapaccomodation"))))

(defrule rule16 (budget ?b&:(fuzzy-match ?b "large"))(distance ?s&:(fuzzy-match ?s "far"))(days ?y&:(fuzzy-match ?y "many"))(accomodation ?a&:(fuzzy-match ?a "costly"))
    =>(assert (recommendation10 (new nrc.fuzzy.FuzzyValue ?*bestlargebudget* "bestavailable"))))


(defrule output1 (recommendation1 ?j&:(fuzzy-match ?j "neardistance"))
    => (printout t "Indianapolis, Indiana" crlf))

(defrule output2(recommendation1 ?j&:(fuzzy-match ?j "fardistance"))
    =>(printout t "Bloomington Gardens, Indiana." crlf))


(defrule output3(recommendation2 ?j&:(fuzzy-match ?j "neardistance"))
    =>(printout t "Starved Rock, Illinois." crlf))

(defrule output4(recommendation2 ?j&:(fuzzy-match ?j "fardistance"))
    =>(printout t "Door County, Wisconsin." crlf))

(defrule output5 (recommendation3 ?j&:(fuzzy-match ?j "fewdays"))
    =>(printout t "Lake Geneva, Wisconsin." crlf))

(defrule output6 (recommendation3 ?j&:(fuzzy-match ?j "manydays"))
    =>(printout t "Indiana Dunes, Indiana." crlf))

(defrule output7 (recommendation4 ?j&:(fuzzy-match ?j "fewdays"))
    =>(printout t "Mackinac, Michigan." crlf))

(defrule output8 (recommendation4 ?j&:(fuzzy-match ?j "manydays"))
    =>(printout t "Upper Peninusla, Michigan." crlf))

(defrule output9 (recommendation5 ?j&:(fuzzy-match ?j "cheapaccomodation"))
    => (printout t "Elkhart Lake, Indiana" crlf))

(defrule output10 (recommendation5 ?j&:(fuzzy-match ?j "costlyaccomodation"))
    => (printout t "Amish County,Indiana." crlf))

(defrule output11 (recommendation6 ?j&:(fuzzy-match ?j "cheapaccomodation"))
    =>(printout t "Carbondale, Illinois" crlf))

(defrule output12 (recommendation6 ?j&:(fuzzy-match ?j "costlyaccomodation"))
    =>  (printout t "Turkey Run Inn, Illinois."  crlf))

(defrule output13 (recommendation7 ?j&:(fuzzy-match ?j "leastavailable"))
    =>(printout t "Rockford, Illinois." crlf))

(defrule output14 (recommendation10 ?j&:(fuzzy-match ?j "bestavailable"))
    =>(printout t "Boulder, Colarado" crlf))

(defrule output15 (recommendation9 ?j&:(fuzzy-match ?j "leastavailable"))
    => (printout t "Indianapolis, Indiana" crlf))

(run)
