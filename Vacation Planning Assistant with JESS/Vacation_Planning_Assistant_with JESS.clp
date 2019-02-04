; Vacation Planning Assitant 
( deftemplate user
  (slot name)
  (slot people)
  (slot budget)
  (slot days)
  (slot experience)
  (slot car)
  (slot accomodation) 
)

; defines question template 
( deftemplate ques 
 (slot ident)
 (slot text)
 (slot type))

; defines answer template
( deftemplate ans
  (slot ident)
  (slot ans)
 )
 

 ;validates the answer entered by the user
 ( deffunction is-type (?ans ?type) 
    (if(or(eq ?type budget)(eq ?type experience))then
        (return(or (or (eq ?ans A)(eq ?ans a))(or (eq ?ans B)(eq ?ans b))(or (eq ?ans C)(eq ?ans c))(or (eq ?ans D)(eq ?ans d))))
            else(if (eq ?type car)then
                  (return (or (or (eq ?ans yes)(eq ?ans Yes))(or (eq ?ans No)(eq ?ans no))))
                    else(if(or(eq ?type days)(eq ?type people))then
                          (return(numberp ?ans))
                            else(if(eq ?type accomodation)then
                              (return(or (or (eq ?ans A)(eq ?ans a))(or (eq ?ans B)(eq ?ans b))))
                            )
                        )
                )
    )
)
 	
;questions to the user 
(deffunction ask-user(?ques ?type)
    (bind ?ans "Something") 
    (while (not (is-type ?ans ?type))do

  
        (if (eq ?type experience)then
	          (printout t crlf "What kind of experience are you looking forward to? [Type in A|B|C]" crlf)
            (printout t "A. Adventure" crlf)
            (printout t "B. Site Seeing & historical stuff" crlf)
            (printout t "C. Some time with nature" crlf))

        (if (eq ?type people)then
	          (printout t crlf "So, How many people? [Type in a number greater than 1]" crlf))

        (if (eq ?type days)then
	          (printout t crlf "How many days are you planning? [Type in a number]" crlf))

        (if (eq ?type budget)then
            (printout t crlf "Let's talk money. What's your budget? [Type in A|B|C] " crlf) 
            (printout t "A. Less than $200" crlf)
            (printout t "B. I'm okay with $200 - $500" crlf)
            (printout t "C. I'm rich." crlf))

          (if (eq ?type car)then
	          (printout t crlf "Are you driving your own car? [Type in Yes|No]" crlf)) 

          (if (eq ?type accomodation)then
	          (printout t crlf "Ofcourse, vacation is not just about travel. Where would you prefer to stay? [Type in A|B] " crlf)
            (printout t "A. AirBNB or a motel works out for me." crlf)
            (printout t "B. Fancy star hotel." crlf)
            )       


        (bind ?ans (read))
    )
    (return ?ans)
 )

 ;displays on triggering the program.
(defrule welcomenote
(declare (salience 100))   
    =>
    (printout t crlf crlf " Hello there! :) What's your name? " crlf)
    (bind ?name (read))
    (assert ( ans (ident name)(ans ?name)))
    (printout t crlf crlf  "============================================================================================" crlf crlf )
    (printout t "Hello " ?name "! I'm your Vacation Planning Assistant" crlf)
    (printout t "Answer these questions and I will try to suggest you a spot for your vacation. Let's get started!" crlf)
    (printout t crlf  "============================================================================================" crlf crlf crlf ))

(defrule ask-question-by-id
(ques (ident  ?id)(text ?text)(type ?type))
(not (ans (ident ?id)))
 ?ask <- (ask ?id)
 =>                        
 (bind ?ans (ask-user ?text ?type))
 (assert (ans (ident ?id)(ans ?ans)))
 (retract ?ask)
 (return)            
  )

(defrule ask-budget	
=>
  (assert(ask budget))      
 ) 

 (defrule ask-car
=>
 (assert(ask car))
)

(defrule ask-days
=>
 (assert(ask days))
)

(defrule ask-experience
=>
 (assert(ask experience))
)

(defrule ask-people
=>
 (assert(ask people))
)

(defrule ask-accomodation
=>
 (assert(ask accomodation))
)

;asserts data
(defrule assert-user-fact
 
  (ans (ident car)(ans ?car)) 
  (ans (ident experience)(ans ?e))    
  (ans (ident name)(ans ?name)) 
  (ans (ident budget)(ans ?bg))
  (ans (ident accomodation)(ans ?ac))
  (ans (ident days)(ans ?days))
  (ans (ident people)(ans ?people))
    =>   
   (assert (user (budget ?bg)(experience ?e)(name ?name)(car ?car)(accomodation ?ac)(days ?days)(people ?people)))
 )
   
;different rules that are to be fired.
(defrule rule1
   (user(budget ?bg&:(or (eq ?bg a)(eq ?bg A)))(experience ?e&:(or (eq ?e a)(eq ?e A))) (days ?d&:(eq ?d 2)) )  
  => 
  (printout t crlf  "The place you should conisder is " crlf " Indiana Dunes, Indiana. ")
)

(defrule rule2
   (user(budget ?bg&:(or (eq ?bg a)(eq ?bg A)))(experience ?e&:(or (eq ?e b)(eq ?e B)))(days ?d&:(eq ?d 2)) )  
  => 
   (printout t crlf  "The place you should conisder is " crlf "Rockford, Illinois." )
)

(defrule rule3
   (user(budget ?bg&:(or (eq ?bg a)(eq ?bg A)))(experience ?e&:(or (eq ?e c)(eq ?e C))) (days ?d&:(eq ?d 2)) )  
  => 
   (printout t crlf  "The place you should conisder is " crlf "Lake Geneva, Wisconsin." )
)

(defrule rule4
   (user(budget ?bg&:(or (eq ?bg b)(eq ?bg B)))(experience ?e&:(or (eq ?e a)(eq ?e A))) (days ?d&:(eq ?d 2)))  
  => 
   (printout t crlf   "The place you should conisder is "  crlf "Bloomington gardens, Indiana" )
)

(defrule rule5
   (user(budget ?bg&:(or (eq ?bg B)(eq ?bg b)))(experience ?e&:(or (eq ?e b)(eq ?e B)))(days ?d&:(eq ?d 2)))  
  => 
   (printout t crlf  "The place you should conisder is " crlf  "Indianapolis, Indiana" )
)

(defrule rule6
   (user(budget ?bg&:(or (eq ?bg B)(eq ?bg b)))(experience ?e&:(or (eq ?e c)(eq ?e C)))(days ?d&:(eq ?d 2)))  
  => 
   (printout t crlf  "The place you should conisder is " crlf  "Crystal Lake, Evanston" )
)

(defrule rule7
   (user(budget ?bg&:(or (eq ?bg c)(eq ?bg C)))(experience ?e&:(or (eq ?e a)(eq ?e A)))(days ?d&:(eq ?d 2)))  
  => 
   (printout t  crlf  "The place you should conisder is " crlf  "Starved Rock, Illinois" )
)
(defrule rule8
   (user(budget ?bg&:(or (eq ?bg c)(eq ?bg C)))(experience ?e&:(or (eq ?e b)(eq ?e B)))(days ?d&:(eq ?d 2)))  
  => 
   (printout t crlf  "The place you should conisder is " crlf  "Door County, Wisconsin" )
)
(defrule rule9
   (user(budget ?bg&:(or (eq ?bg c)(eq ?bg C)))(experience ?e&:(or (eq ?e c)(eq ?e C)))(days ?d&:(eq ?d 2)))  
  => 
   (printout t crlf  "The place you should conisder is " crlf  "Fox River Valley, Illinois" )
)

(defrule rule10
   (user(budget ?bg&:(or (eq ?bg a)(eq ?bg A)))(experience ?e&:(or (eq ?e a)(eq ?e A))) (days ?d&:(and (> ?d 2)(< ?d 5))))  
  => 
   (printout t crlf  "The place you should conisder is " crlf  "Elkhart Lake, Indiana" )
)

(defrule rule11
   (user(budget ?bg&:(or (eq ?bg a)(eq ?bg A)))(experience ?e&:(or (eq ?e b)(eq ?e B)))(days ?d&:(and (> ?d 2)(< ?d 5))))  
  => 
   (printout t crlf  "The place you should conisder is " crlf "Amish County,Indiana" )
)

(defrule rule12
   (user(budget ?bg&:(or (eq ?bg a)(eq ?bg A)))(experience ?e&:(or (eq ?e c)(eq ?e C))) (days ?d&:(and (> ?d 2)(< ?d 5))))  
  => 
   (printout t crlf  "The place you should conisder is " crlf "Bloomington,Indiana" )
)

(defrule rule13
   (user(budget ?bg&:(or (eq ?bg b)(eq ?bg B)))(experience ?e&:(or (eq ?e a)(eq ?e A))) (days ?d&:(and (> ?d 2)(< ?d 5))))  
  => 
   (printout t crlf  "The place you should conisder is " crlf "Turkey Run Inn, Illinois" )
)

(defrule rule14
   (user(budget ?bg&:(or (eq ?bg B)(eq ?bg b)))(experience ?e&:(or (eq ?e b)(eq ?e B))) (days ?d&:(and (> ?d 2)(< ?d 5)))  )  
  => 
   (printout t crlf  "The place you should conisder is "  crlf  "Miluwake, Wisconsin" )
)

(defrule rule15
   (user(budget ?bg&:(or (eq ?bg B)(eq ?bg b)))(experience ?e&:(or (eq ?e c)(eq ?e C))) (days ?d&:(and (> ?d 2)(< ?d 5))))    
  => 
   (printout t crlf  "The place you should conisder is "  crlf  "Galena, Illinois" )
)

(defrule rule16
   (user(budget ?bg&:(or (eq ?bg c)(eq ?bg C)))(experience ?e&:(or (eq ?e a)(eq ?e A))) (days ?d&:(and (> ?d 2)(< ?d 5)))  )  
  => 
   (printout t  crlf  "The place you should conisder is "  crlf   "St. Louis, Missouri" )
)
(defrule rule17
   (user(budget ?bg&:(or (eq ?bg c)(eq ?bg C)))(experience ?e&:(or (eq ?e b)(eq ?e B)))(days ?d&:(and (> ?d 2)(< ?d 5))))    
  => 
   (printout t crlf  "The place you should conisder is "  crlf  "Madison, Wisconsin" )
)
(defrule rule18
   (user(budget ?bg&:(or (eq ?bg c)(eq ?bg C)))(experience ?e&:(or (eq ?e c)(eq ?e C)))(days ?d&:(and (> ?d 2)(< ?d 5))) )   
  => 
   (printout t crlf  "The place you should conisder is "  crlf  "Carbondale, Illinois" )
)

(defrule rule19
   (user(budget ?bg&:(or (eq ?bg a)(eq ?bg A)))(experience ?e&:(or (eq ?e a)(eq ?e C=A)))(days ?d&:(and (> ?d 5)(< ?d 7))) )   
  => 
   (printout t crlf  "The place you should conisder is "  crlf  "Upper Peninusla, Michigan" )
)
(defrule rule20
   (user(budget ?bg&:(or (eq ?bg a)(eq ?bg A)))(experience ?e&:(or (eq ?e b)(eq ?e B)))(days ?d&:(and (> ?d 5)(< ?d 7)))  )  
  => 
   (printout t crlf  "The place you should conisder is "   crlf  "Mackinac, Michigan" )
)
(defrule rule21
   (user(budget ?bg&:(or (eq ?bg a)(eq ?bg A)))(experience ?e&:(or (eq ?e c)(eq ?e C)))(days ?d&:(and (> ?d 5)(< ?d 7))) )  
  => 
   (printout t crlf "The place you should conisder is "  crlf   "Maine" )
)
(defrule rule22
   (user(budget ?bg&:(or (eq ?bg b)(eq ?bg b)))(experience ?e&:(or (eq ?e a)(eq ?e A)))(days ?d&:(and (> ?d 5)(< ?d 7)))  )  
  => 
   (printout t   "The place you should conisder is "  crlf  "Benthany Beach, Michigan" )
)
(defrule rule23
   (user(budget ?bg&:(or (eq ?bg b)(eq ?bg b)))(experience ?e&:(or (eq ?e b)(eq ?e b)))(days ?d&:(and (> ?d 5)(< ?d 7))) )   
  => 
   (printout t crlf "The place you should conisder is "  crlf  "NYC, New York." )
)
(defrule rule24
   (user(budget ?bg&:(or (eq ?bg b)(eq ?bg c)))(experience ?e&:(or (eq ?e c)(eq ?e C)))(days ?d&:(and (> ?d 5)(< ?d 7)))  )  
  => 
   (printout t crlf "The place you should conisder is " crlf  "New Orleans,Louisiana." )
)
(defrule rule25
   (user(budget ?bg&:(or (eq ?bg c)(eq ?bg C)))(experience ?e&:(or (eq ?e a)(eq ?e A)))(days ?d&:(and (> ?d 5)(< ?d 7)))  )  
  => 
   (printout t crlf "The place you should conisder is " crlf  "Boulder, Colarado" )
)
(defrule rule26
   (user(budget ?bg&:(or (eq ?bg c)(eq ?bg C)))(experience ?e&:(or (eq ?e b)(eq ?e B)))(days ?d&:(and (> ?d 5)(< ?d 7)))  )  
  => 
   (printout t crlf "The place you should conisder is " crlf  "San Fransico, California" )
)
(defrule rule27
   (user(budget ?bg&:(or (eq ?bg c)(eq ?bg C)))(experience ?e&:(or (eq ?e c)(eq ?e C)))(days ?d&:(and (> ?d 5)(< ?d 7))) )   
  => 
   (printout t crlf "The place you should conisder is " crlf  "Miami, Florida" )
)
(defrule rule28
   (user(car yes)(accomodation ?ac&:(or (eq ?ac a)(eq ?ac A))))  
  => 
   (printout t crlf  "Since you own a car and you are willing to opt for cheaper accomodation, you are good!")
)
(defrule rule29
   (user(car yes)(accomodation ?ac&:(or (eq ?ac b)(eq ?ac B))))    
  => 
   (printout t crlf  "Since you own a car, you are cutting some of your expense on your travel with which you will be able to afford for a better accomodation")
)
(defrule rule30
   (user(car no)(accomodation ?ac&:(or (eq ?ac a)(eq ?ac A))))   
  => 
   (printout t crlf  "Your travel expense could be compensated by opting for a cheap AirBnb")
)
(defrule rule31
   (user(car no)(accomodation ?ac&:(or (eq ?ac b)(eq ?ac B)))(budget ?bg&:(or (eq ?bg a)(eq ?bg A))))  
  => 
   (printout t crlf  "Since you will be spending more on your travel and accomodation, your trip might go over the budget.")
)
(defrule rule32
   (user(car no)(accomodation ?ac&:(or (eq ?ac b)(eq ?ac B)))(budget ?bg&:(or (eq ?bg b)(eq ?bg )B(eq ?bg c)(eq ?bg C))))  
  => 
   (printout t crlf  "You should be able to manage your travel and accomodation within the budget.")
)
(defrule rule33
   (user(days ?d&:(eq ?d 1)))  
  => 
   (printout t crlf  "Since you just have a day, somewhere in Chicago maybe.")
)
(defrule rule34
   (user(days ?d&:(< ?d 1)) ) 
  => 
   (printout t crlf  "O days? Netflix and chill buddy! ")
)
(defrule rule35
   (user(days ?d&:(> ?d 6))(budget ?bg&:(or (eq ?bg c)(eq ?bg C))))
  => 
   (printout t crlf  " You should probably drive across the country or perhaps plan for a foreign tour! ")
)
(defrule rule36
   (user(days ?d&:(> ?d 6))(budget ?bg&:(or (eq ?bg a)(eq ?bg A))))  
  => 
   (printout t crlf  "Since you are planning more many days and your budget is lesser you, try again with different no of days. ")
)

(deffacts test-fact
 (ques (ident people)(type people)
    (text " "))
(ques (ident car)(type car)
     (text " "))  
(ques (ident budget)(type budget)
   (text "")) 
(ques (ident accomodation)(type accomodation)
     (text " ")) 
(ques (ident days)(type days)
    (text " "))
(ques (ident experience)(type experience)
   (text " "))
  )  
  
;triggers the program
  (reset)
	(run)

