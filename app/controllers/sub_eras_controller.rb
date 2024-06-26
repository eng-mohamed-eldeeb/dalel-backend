class SubErasController < ApplicationController
  def index
    era = Era.find(params[:era_id])
    sub_eras = era.sub_eras
    sub_eras = sub_eras.each do |sub_era|
      {
        id: sub_era.id,
        name: I18n.locale.to_s == 'ar' ? sub_era.arabic_name : sub_era.english_name,
      }
    end
    render json: {sub_eras: sub_eras}
  end

  def show
    sub_era = SubEra.find(params[:id])
    eight_characters = sub_era.get_characters
    characters_to_be_returned = eight_characters.map do |character|
      {
        id: character.id,
        name: I18n.locale.to_s == 'ar' ? character.arabic_name : character.english_name,
        thumb_image: url_for(character.thumb_image)
      }
    end

    eight_events = sub_era.get_events
    events_to_be_returned = eight_events.map do |event|
      {
        id: event.id,
        title: I18n.locale.to_s == 'ar' ? event.arabic_title : event.english_title,
        image: url_for(event.cover_image)
      }
    end

    render json: {
      sub_era: {
        id: sub_era.id,
        name: I18n.locale.to_s == 'ar' ? sub_era.arabic_name : sub_era.english_name,
        info: I18n.locale.to_s == 'ar' ? sub_era.arabic_info : sub_era.english_info,
        era_id: sub_era.era_id,
        sections: serialize_sections(sub_era.sections, I18n.locale)
      },
      character: characters_to_be_returned,
      events: events_to_be_returned
    }
  end

  def add_points
    sub_era = SubEra.find(params[:id])
    sub_era.point += 1
    era = sub_era.era
    user = User.find(params[:user_id])
    if SubEraPoint.where(user: user, sub_era: sub_era).empty?
      sub_era_p = SubEraPoint.create(sub_era: sub_era, user: user, points: 1)
      render json: { message: 'point added' }, status: :ok
      return
    end
    sub_era_point = SubEraPoint.find_by(sub_era: sub_era, user: user)
    sub_era_point.update(points: sub_era_point.points + 1)
    sub_era_point.set_tier(user)
    sub_era_point.save
    render json: { message: 'point added' }, status: :ok
  end

  def search
    search_term = params[:search][:english_name]

    sub_eras = SubEra.where("english_name ILIKE ?", "%#{search_term}%")
    sub_eras = sub_eras.map do |sub_era|
      {
        id: sub_era.id,
        name: I18n.locale.to_s == 'ar' ? sub_era.arabic_name : sub_era.english_name,
        era_id: sub_era.era.name
      }
    end
    render json: { sub_eras: sub_eras }
  end

  private

  def serialize_sub_eras(sub_eras)
    sub_eras.map do |sub_era|
      {
        en: serialize_language(sub_era, :english),
        ar: serialize_language(sub_era, :arabic)
      }
    end
  end

  def serialize_language(sub_era, language)
    {
      name: sub_era.send("#{language}_name"),
      info: sub_era.send("#{language}_info"),
      sections: serialize_sections(sub_era.sections, language)
    }
  end

  def serialize_sections(sections, language)
    sections.map do |section|
      {
        title: I18n.locale.to_s == 'ar' ? section.arabic_title : section.english_title,
        content: I18n.locale.to_s == 'ar' ? section.arabic_content : section.english_content
      }
    end
  end
end
