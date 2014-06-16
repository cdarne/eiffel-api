# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
require "pp"

Survey.transaction do
  s1 = Survey.create!(description: "Template de Questionnaire pour l'association française de réputation des parisiens émigrés dans le monde. Copyright NosQuestions, VosRéponses Inc.")

  q1 = s1.questions.create!(order: 1, description: "Connaissez-vous des français ?",
                            question_type: Question::TYPE[:boolean], weight: 1)
  q2 = s1.questions.create!(order: 2, description: "Connaissez-vous des français résidant à Paris ?",
                            question_type: Question::TYPE[:boolean], weight: 1, dependent_question: q1)

  q3 = s1.questions.create!(order: 3, description: "Combien de parisiens connaissez-vous ?",
                            question_type: Question::TYPE[:select], weight: 1, dependent_question: q2)
  sv1 = q3.create_select_value!(multiple: false)
  sv1.values.create!(order: 1, description: "de 1 à 5", score: 1)
  sv1.values.create!(order: 2, description: "de 6 à 10", score: 2)
  sv1.values.create!(order: 3, description: "de 11 à 50", score: 3)
  sv1.values.create!(order: 4, description: "plus de 50", score: 4)

  q4 = s1.questions.create!(order: 4, description: "Sur tous les parisiens que vous connaissez, pour les {{questions[3].values[responses[3]]}} personnes les plus amicales, notez chaque de 1 à 5 selon votre appréciation",
                            question_type: Question::TYPE[:select], weight: 1, dependent_question: q3)
  sv2 = q4.create_select_value!(multiple: false)
  sv2.values.create!(order: 1, description: "très amical, fait partie de ma famille", score: 1)
  sv2.values.create!(order: 2, description: "amical", score: 2)
  sv2.values.create!(order: 3, description: "neutre", score: 3)
  sv2.values.create!(order: 4, description: "assez inamical", score: 4)
  sv2.values.create!(order: 5, description: "odieux la plupart du temps", score: 5)

  q5 = s1.questions.create!(order: 5, description: "Sur tous les autres parisiens que vous connaissez, notez chaque de 1 à 5 selon votre appréciation",
                            question_type: Question::TYPE[:select], weight: 1, dependent_question: q3)
  sv3 = q5.create_select_value!(multiple: false)
  sv3.values.create!(order: 1, description: "très amical, fait partie de ma famille", score: 1)
  sv3.values.create!(order: 2, description: "amical", score: 2)
  sv3.values.create!(order: 3, description: "neutre", score: 3)
  sv3.values.create!(order: 4, description: "assez inamical", score: 4)
  sv3.values.create!(order: 5, description: "odieux la plupart du temps", score: 5)

  q6 = s1.questions.create!(order: 6, description: "Selon votre perception, notez de 1 à 5 votre appréciation de la réputation des parisiens (en général)",
                            question_type: Question::TYPE[:select], weight: 1, dependent_question: q3)
  sv4 = q6.create_select_value!(multiple: false)
  sv4.values.create!(order: 1, description: "très amical, fait partie de ma famille", score: 1)
  sv4.values.create!(order: 2, description: "amical", score: 2)
  sv4.values.create!(order: 3, description: "neutre", score: 3)
  sv4.values.create!(order: 4, description: "assez inamical", score: 4)
  sv4.values.create!(order: 5, description: "odieux la plupart du temps", score: 5)
end

Survey.transaction do
  s2 = Survey.create!(description: "Template de Questionnaire pour l'association française de réputation des parisiens émigrés dans le monde. Copyright ParisMonAmi Inc.")

  q1 = s2.questions.create!(order: 1, description: "Combien de parisiens avez-vous dans vos connaissances ?",
                            question_type: Question::TYPE[:input], weight: 1)
  q2 = s2.questions.create!(order: 2, description: "Combien de parisiens considérez-vous comme plus que de simples connaissance ?",
                            question_type: Question::TYPE[:input], weight: 1)

  q3 = s2.questions.create!(order: 3, description: "Selon vos connaissances, notez votre appréciation des parisiens :",
                            question_type: Question::TYPE[:rating], weight: 1)
  rv1 = q3.create_rating_value(min: 1, max: 5, step: 1)
  rv1.values.create!(order: 1, description: "respect des autres")
  rv1.values.create!(order: 2, description: "ponctualité")
  rv1.values.create!(order: 3, description: "politesse")
  rv1.values.create!(order: 4, description: "acueillant")
  rv1.values.create!(order: 5, description: "indifférent")
  rv1.values.create!(order: 6, description: "français")

  q4 = s2.questions.create!(order: 4, description: "Adopteriez vous un parisiens comme ami ?",
                            question_type: Question::TYPE[:boolean], weight: 1)
end

Survey.transaction do
  s3 = Survey.create!(description: "Template de Questionnaire pour l'association française de réputation des parisiens émigrés dans le monde. Copyright SondageMieux Inc.")
  q1 = s3.questions.create!(order: 1, description: "Dans le camembert graphique suivant, saisissez la proportion de chaque qualité que vous associez à un parisien :",
                            question_type: Question::TYPE[:ratio], weight: 1)
  rav1 = q1.create_ratio_value
  rav1.values.create!(order: 1, description: "sympathique")
  rav1.values.create!(order: 2, description: "joyeux")
  rav1.values.create!(order: 3, description: "chaleureux")
  rav1.values.create!(order: 4, description: "généreux")

  q2 = s3.questions.create!(order: 2, description: "Dans le camembert graphique suivant, saisissez la proportion de chaque défaut que vous associez à un parisien :",
                            question_type: Question::TYPE[:ratio], weight: 1)
  rav2 = q2.create_ratio_value
  rav2.values.create!(order: 1, description: "bavard")
  rav2.values.create!(order: 2, description: "ennuyeux")
  rav2.values.create!(order: 3, description: "stressé")
  rav2.values.create!(order: 4, description: "prétentieux")
end