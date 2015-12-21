class PetitionMailer <  ApplicationMailer

  #ask signatories with any pledge to adopt orphaned petition
  def adoption_request_signatory_mail(petition, signature)
    @petition = petition
    @signature = signature

    if signature.unique_key.nil?
      signature.send(:generate_unique_key)
      signature.save
    end

    @become_owner_url = url_for(
      controller: 'signatures',
      action: 'become_petition_owner',
      host: 'dev.petitions.eu',
      signature_id: @signature.unique_key)

    subject = t('petition.moderation.we_need_new_owner')

    mail(to: @signature.person_email, subject: subject)
  end

  # ask office which date petition should get an answer
  def ask_office_answer_due_date_mail(petition)
    Logger.debug('build ask for answer due date mail..')

    @office = petition.office

    subject = t('petition.office.please_answer')

    @petition = petition

    mail(to: @petition.office.email, subject: subject)
  end

  # ask office for answer to petition
  def ask_office_for_answer_mail(petition)
    Logger.debug('build ask for answer mail..')

    subject = t('petition.moderation.we_need_answer')

    mail(to: @petition.office.email, subject: subject)

  end

  # call petitioner into action about closing petition
  def due_next_week_warning_mail(petition)

    subject = t('petition.is.due')
    target = petition.office.email
    mail(to: target, subject: subject)
  end

  # finalize petition, ready for moderation
  def finalize_mail(petition, target: nil)

    @petition = petition

    if target.nil?
      target = @petition.office.email
    end

    subject = t('mail.moderation.pending_subject')

    mail(to: target, subject: subject)

  end

  # petitioner with failed petition asked to fix it
  def improve_and_reopen_mail
    @signature = signature
    @petition = petition
    @user = user
    subject = t('mail.petition.improve_and_reopen_subject', {
       petition_name: petition.name
     })
     mail(to: user.email, subject: subject)
    
  end

  # signatory gets the answer to the petition
  def inform_user_of_answer_mail(signature, petition, answer)
    @signature = signature
    @petition = petition
    @answer = answer
    @unique_key = url_for(
      controller: 'signatures',
      action: 'confirm',
      host: 'petities.nl',
      signature_id: @signature.unique_key)

    subject = t('mail.petition.is_answered', {
      title: @petition.name})

    mail(from: 'bounces@petities.nl', reply_to: 'webmaster@petities.nl', to: signature.person_email, subject: subject)
  end

  # announce petition to office
  def petition_announcement_mail(petition)

    @petition = petition
    @office = petition.office
    target = @petition.office.email
    subject = t('mail.request.announcement_subject')
    mail(to: target, subject: subject )
  end

  # explain office what we expect
  def process_explanation_mail(petition)
    @petition = petition
    @office = petition.office
    target = @petition.office.email
    subject = t('mail.request.procedural_subject')
    mail(to: target, subject: subject )    
  end  
  
  # ask office for reference number
  def reference_number_mail(petition, target="")
    Logger.debug('building reference number mail..')
    @petition = petition
    @office = petition.office
    target = @petition.office.email
    subject = t('mail.request.announcement_subject')
    mail(to: target, subject: subject )

    if not target
      target = @petition.office.email
    end
  end

  # each petition status change by e-mail to admin
  def status_change_mail(petition, target: nil)
    @petition = petition

    subject = t('mail.petition.status.changed_subject')

    if target.nil?
      # NOTE petitioner_email can be wrong?
      # should we not send email to admin users?
      target = @petition.petitioner_email
    end

    if @petition.petitioner_email
      mail(to: target, subject: subject )
    end
  end

  # a virtual hand over of the signatories list
  def hand_over_to_office_mail
    PetitionMailer.hand_over_to_office_mail(Petition.live.first)
  end

  # all signatories get a mail that the hand over took place
  def handed_over_signatories_mail
    PetitionMailer.handed_over_signatories_mail(Petition.live.first)
  end

  # petitioner is asked to write an update about the hand over
  def write_about_hand_over_mail
    PetitionMailer.write_about_hand_over_mail(Petition.live.first)
  end

  # ask petitioner to confirm, give user and password
  def welcome_petitioner_mail(petition, user, password)

    @user = user
    @password = password
    @token = user.confirmation_token
    @password = password
    @petition = petition

    subject = t('mail.petition.confirm.subject', {
      petition_name: petition.name
    })

    mail(to: user.email, subject: subject)
  end
  
end
