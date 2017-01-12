def from_celsius(degrees, to_unit)
  case to_unit
  when 'C' then degrees
  when 'K' then degrees + 273.15
  when 'F' then degrees * 1.8 + 32
  end
end

def to_celsius(degrees, from_unit)
  case from_unit
  when 'C' then degrees
  when 'K' then degrees - 273.15
  when 'F' then (degrees - 32) / 1.8
  end
end

def convert_between_temperature_units(degrees, input_unit, output_unit)
  degrees_in_celsius = degrees_to_celsius(degrees, input_unit)
  degrees_from_celsius(degrees_in_celsius, output_unit)
end

SUBSTANCES = {
  'water'   => { melting_point: 0, boiling_point: 100 },
  'ethanol' => { melting_point: -114, boiling_point: 78.37 },
  'gold'    => { melting_point: 1_064, boiling_point: 2_700 },
  'silver'  => { melting_point: 961.8, boiling_point: 2_162 },
  'copper'  => { melting_point: 1_085, boiling_point: 2_567 },
}

def melting_point_of_substance(substance, unit)
  degrees_from_celsius(SUBSTANCES[substance][:melting_point], unit)
end

def boiling_point_of_substance(substance, unit)
  degrees_from_celsius(SUBSTANCES[substance][:boiling_point], unit)
end
