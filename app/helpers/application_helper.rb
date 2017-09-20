module ApplicationHelper
  def module_item
    # get module from route namespace
    case request.fullpath.split("/")[1]
    when 'my_fifa'
      content_tag(:div, nil, class: 'module item') do
        content_tag(:i, nil, class: 'soccer icon') +
        'MyFIFA Manager'
      end
    else
      nil
    end
  end
end
