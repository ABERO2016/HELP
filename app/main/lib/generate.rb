Volt.skip_permissions do
  buffer = Volt.current_app.store.users.buffer
  buffer._first_name = 'Erik'
  buffer._last_name = 'Gabrielsen'
  buffer._email = 'egabrielsen@smu.edu'
  buffer._major = 'Computer Science'
  buffer._graduation_year = '2007'
  buffer._smu_id = '40354578'
  buffer._role = 'Student'
  buffer._survey_status = 'taken'
  buffer._mkrg = 'email'
  buffer._password = 'sharpclaw'
  buffer.save!.then do
    puts 'saved'
  end.fail do |err|
    puts "#{err}"
  end

  Volt.current_app.store.users.where(smu_id: '40354578').first.then do |user|
    survey = Volt.current_app.store._surveyforms.buffer
    survey._user_id = user.id
    survey._competency_one = 'Champions Effective Processing'
    survey._competency_two = 'Self Awareness'
    survey._date = Time.now
    survey._q9_0 = 2
    survey._q9_1 = 3
    survey._q9_2 = 4
    survey._q9_3 = 2
    survey._q10_0 = 2
    survey._q10_1 = 3
    survey._q10_2 = 4
    survey._q10_3 = 3
    survey._q10_4 = 1

    survey._good_leader = 'Bush'
    survey._bad_leader = 'Obama'

    survey._q12_0_c = 4
    survey._q12_1_c = 4
    survey._q12_2_c = 3
    survey._q12_3_c = 2
    survey._q12_4_c = 4

    survey._q13_0_c = 1
    survey._q13_1_c = 2
    survey._q13_2_c = 3
    survey._q13_3_c = 4
    survey._q13_4_c = 3

    survey._q14_0_c = 3
    survey._q14_1_c = 4
    survey._q14_2_c = 2
    survey._q14_3_c = 3
    survey._q14_4_c = 2

    survey._q15_0_c = 3
    survey._q15_1_c = 4
    survey._q15_2_c = 3
    survey._q15_3_c = 2
    survey._q15_4_c = 2


    survey._q16_0_c = 2
    survey._q16_1_c = 2
    survey._q16_2_c =2
    survey._q16_3_c =3
    survey._q16_4_c =4
    # Directive Leadership
    survey._q17_0_c = 4
    survey._q17_1_c = 4
    survey._q17_2_c = 4
    survey._q17_3_c = 4
    survey._q17_4_c = 4

    # Champions Effective Processes
    survey._q18_0_c = 4
    survey._q18_1_c =3
    survey._q18_2_c =2
    survey._q18_3_c =3
    survey._q18_4_c =2

    # Problem Solving
    survey._q19_0_c =3
    survey._q19_1_c =2
    survey._q19_2_c =3
    survey._q19_3_c =2
    survey._q19_4_c =4

    # Strategic Perspective
    survey._q20_0_c =3
    survey._q20_1_c =2
    survey._q20_2_c =1
    survey._q20_3_c =2
    survey._q20_4_c =4

    # Ethics and Integrity
    survey._q21_0_c =2
    survey._q21_1_c =3
    survey._q21_2_c =2
    survey._q21_3_c =1
    survey._q21_4_c =1

    # Innovative Spirit
    survey._q22_0_c =2
    survey._q22_1_c =3
    survey._q22_2_c =2
    survey._q22_3_c =1
    survey._q22_4_c =1
    survey.save!.then do
      puts 'saved'
    end.fail do |err|
      puts "#{err}"
    end
  end

  buffer = Volt.current_app.store.users.buffer
  buffer._first_name = 'Admin'
  buffer._last_name = 'Test'
  buffer._email = 'adminTest@smu.edu'
  buffer._major = 'Other'
  buffer._graduation_year = '2017'
  buffer._smu_id = '00000000'
  buffer._role = 'Admin'
  buffer._survey_status = 'not taken'
  buffer._mkrg = 'email'
  buffer._password = 'tester123'
  buffer.save!.then do
    puts 'saved'
  end.fail do |err|
    puts "#{err}"
  end

end
