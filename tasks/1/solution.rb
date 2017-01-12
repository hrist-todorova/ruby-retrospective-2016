def from_celsius(degrees, unit)
  case unit
  when 'C' then degrees
  when 'K' then degrees + 273.15
  when 'F' then (degrees * 1.8) + 32
  end
end

def to_celsius(degrees, unit)
  case unit
  when 'C' then degrees
  when 'K' then degrees - 273.15
  when 'F' then (degrees - 32) / 1.8
  end
end

def convert_between_temperature_units(degrees, input_unit, output_unit)
  return degrees if input_unit == output_unit

  case input_unit
  when 'C' then from_celsius(degrees, output_unit)
  when 'K' then from_celsius(to_celsius(degrees, 'K'), output_unit)
  when 'F' then from_celsius(to_celsius(degrees, 'F'), output_unit)
  end
end

MELTNG_POINTS = {
  'water' => 0,
  'ethanol' => -114,
  'gold' => 1064,
  'silver' => 961.8,
  'copper' => 1085
}

BOILING_POINS = {
  'water' => 100,
  'ethanol' => 78.37,
  'gold' => 2700,
  'silver' => 2162,
  'copper' => 2567
}

def melting_point_of_substance(substance, unit)
  convert_between_temperature_units(MELTNG_POINTS[substance], 'C', unit)
end

def boiling_point_of_substance(substance, unit)
  convert_between_temperature_units(BOILING_POINS[substance], 'C', unit)
end
