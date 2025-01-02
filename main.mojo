from python import Python

struct Question(Copyable):
    var text: String

    fn __init__(inout self, text: String):
        self.text = text

    fn __copyinit__(inout self, existing: Self):
        self.text = existing.text

    fn __moveinit__(inout self, owned existing: Self):
        self.text = existing.text

struct CTFChallenge:
    var name: String
    var difficulty: Int
    var questions: List[Question]
    var answers: List[String] 
    
    fn __init__(inout self, name: String, difficulty: Int, questions: List[Question]):
        self.name = name
        self.difficulty = difficulty
        self.questions = questions
        self.answers = List[String](self.questions.size()) 

    fn display_info(self):
        print("Challenge Name:", self.name)
        print("Difficulty:", self.difficulty)
        print("Questions:")
        var i = 0
        for question_ptr in self.questions:
            var question = question_ptr[]
            print("-", question.text)
            # Prompt the user for an answer
            var user_answer = input("Your answer: ")
            self.answers[i] = user_answer
            i = i + 1

    fn display_result(self) raises:
        print("Congratulations! You've completed the challenge. Generating result...\n")
        var base_url = "https://meuctf.supersecreto.net/result"
        var query_string = self.create_query_string()
        var result_url = String.write(base_url, "?", query_string)
        print("Access the result here:", result_url)

    fn create_query_string(self) raises -> String:
        var query_string: String = "" 
        var i = 0
        for question_ptr in self.questions:
            var question = question_ptr[]  
            # Prompt the user for an answer to each question
            var user_answer = input("Your answer for the question '{}': ".format(question.text))
            if i > 0:
                query_string = query_string + "&"
            query_string = query_string + "answer" + str(i + 1) + "=" + user_answer
            i = i + 1
        return query_string

fn main() raises:
    # List of questions
    var questions = List[Question]()
    questions.append(Question("What is the capital of France?"))
    questions.append(Question("What is the result of 2 + 2?"))
    questions.append(Question("Who wrote 'Don Quixote'?"))

    # Instance of CTFChallenge 
    var challenge = CTFChallenge("Sample Challenge", 5, questions)
    challenge.display_info()
    challenge.display_result()
