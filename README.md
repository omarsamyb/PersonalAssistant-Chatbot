# PersonalAssistant-Chatbot
A Health Personal Assistant Chabot.


### Chatbot Main Functionalities
Our Prolog personal assistant is specifically built to help its users regarding what they could eat. The
assistant should give information about food ingredients, calories, and meals.
* The assistant receives questions from the user and answers them.

* The user gets back those answers and asks more questions, if he/she wants to.

* It can also receive information about the user, for example, what he/she had for a specific meal.

* In order to have a more intelligent agent, the chatbot should keep track of the previously asked
questions and responses.

* At the end, the assistant should print a report for the user about the food he/she ate during the
day.

### Chatbot Knowledge Base
The program will know information about the following (which is in info_food.pl):
* Total Number of Calories to consume in one day
* Food Names
* Food Ingredients
* Food Categories
* Food Calories
* Meals, and which Food Names can be eaten at them

### User Language
The user is allowed to ask one of the following questions:

a) How many calories does [a food type / a food ingredient] contain?
> Example: How many calories does cheese contain?

b) What does [a food type] contain?
> Example: What does green_salad contain?

c) Can I have [a food type] for [a meal type]?
> Example: Can I have croissant for breakfast?

d) What is [a food ingredient]?
> Example: What is fig?

e) How many calories do I have left?

f) What kind of [a food category] does [a food type] contain?
> Example: What kind of protein does pizza contain?

g) Is [a food ingredient] a [a food category] in [a food type]?
> Example: Is minced_meat a protein in lasagne?

h) What can I have for [a meal type] that contains [a food ingredient]?
> Example: What can I have for lunch that contains pasta?

In addition to that, the user can state one of the following facts:

a) I ate [a food type] for [a meal type].
> Example: I ate pizza for lunch.

b) I do not eat [a food ingredient].
> Example: I do not eat fish.

If the user wants to end the communication session with the assistant, the user should write the following
command:
> quit.

### Assistant Language
The assistant begins the communication with the user by printing the following prompt:
> Welcome to your personal assistant
The assistant can reply to any correctly formatted user question with one of the following statements:

a) [a food type]
> Example: pizza

b) [a food ingredient]
> Example: hotdog

c) [a food category]
> Example: fruit

d) [Number] Calories
> Example: 187 Calories

e) You can have [a food type] for [a meal type]
> Example: You can have yogurt for dinner

f) [a food type] is not suitable for [a meal type]
> Example: fried_chicken is not suitable for breakfast

g) I do not know

h) I told you that before

i) Nothing from what I know

j) Yes

k) No

If the user asks or states something which is not correctly formatted or not in the language described
above, the assistant should reply with the following statement:
> I can not understand you

In case the user stated a fact in one of the two possible forms, the assistant will only confirm reading the
statement correctly by saying:
> Ok

If the user commanded to end the session by writing quit., the assistant should print a report for the
user mentioning what the user ate in each meal. The report should have the following form:
> You had [a food type / - ] for breakfast

> You had [a food type / - ] for lunch

> You had [a food type / - ] for dinner

> Bye

### Example of Running Script
Input is in **Bold**

?- **readInputTillQuit**
> Welcome to your personal assistant

> **weird sentence.**

> I can not understand you

> **How many calories do I have left?**

> 1800 Calories

> **How many calories does cheese contain?**

> 431 Calories

> **I ate spanish_omelette for breakfast.**

> Ok

> **How many calories does spanish_omelette contain?**

> 481 Calories

> **how many calories do I have left?**

> 1319 Calories

> **What kind of vegetable does green_salad contain?**

> tomato

> **what kind of vegetable does green_salad contain?**

> onion

> **what kind of vegetable does green_salad contain?**

> lettuce

> **Is tomato a vegetable in pizza?**

> Yes

> **Is tomato a vegetable in pizza?**

> I told you before

> **What kind of fat does pizza contain?**

> oil

> **I ate pizza for lunch.**

> Ok

> **how many calories do i have left?**

> 273 Calories

> **can I have fried_chicken for dinner?**

> fried_chicken is not suitable for dinner

> **How many calories does yogurt contain?**

> 218 Calories

> **can I have yogurt for dinner?**

> You can have yogurt for dinner

> **quit.**

> You had spanish_omelette for breakfast

> You had pizza for lunch

> You had yogurt for dinner

> Bye
