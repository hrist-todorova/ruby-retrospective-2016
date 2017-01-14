RSpec.describe 'Version' do
  describe '#initialize' do
    it 'initializes correctly with valid input' do
      expect(Version.new('1.1.5')).to eq '1.1.5'
      expect(Version.new('1.13.3')).to eq '1.13.3'
      expect(Version.new('1.105.0')).to eq '1.105'
      expect(Version.new('1.2.3.4.600')).to eq '1.2.3.4.600'
      expect(Version.new('20.0.0.0')).to eq '20'
      expect(Version.new('2.0.0.1')).to eq '2.0.0.1'
    end

    it 'accepts the empty string as argument' do
      expect(Version.new('')).to eq '0'
    end

    it 'initializes without any argument' do
      expect(Version.new).to eq '0'
    end

    context 'raises error for invalid input' do
      it 'correctly describes the error with not valid input' do
        expect { Version.new('1.2.string') }.to raise_error(
          ArgumentError,
          "Invalid version string '1.2.string'"
        )
      end

      it 'raises error when the argument has incorect number of points' do
        expect { Version.new('.3') }.to raise_error(ArgumentError)
        expect { Version.new('....3') }.to raise_error(ArgumentError)
        expect { Version.new('0..3') }.to raise_error(ArgumentError)
        expect { Version.new('1.3.5.') }.to raise_error(ArgumentError)
        expect { Version.new('1...') }.to raise_error(ArgumentError)
      end

      it 'raises error when the argument has other symbols than points and digits' do
        expect { Version.new('2,1,3') }.to raise_error(ArgumentError)
        expect { Version.new('2-3-1') }.to raise_error(ArgumentError)
        expect { Version.new('2.3,1') }.to raise_error(ArgumentError)
        expect { Version.new('2*3') }.to raise_error(ArgumentError)
      end

      it 'raises error when the argument has negative numbers' do
        expect { Version.new('-1') }.to raise_error(ArgumentError)
        expect { Version.new('-12332.23') }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'comparing versions' do
    it 'compares simple inequalities' do
      expect(Version.new('1')    ).to be > Version.new('0')
      expect(Version.new('0.1')  ).to be > Version.new('0')
      expect(Version.new('0.0.1')).to be > Version.new('0')
      expect(Version.new('0')    ).to_not be > Version.new('0.0.1')

      expect(Version.new('1')    ).to be < Version.new('1.0.1')
      expect(Version.new('1.1')  ).to be < Version.new('1.1.1')
      expect(Version.new('11.3') ).to be < Version.new('11.3.1')
      expect(Version.new('1.0.1')).to_not be < Version.new('1')

      expect(Version.new('1.23')).to be > Version.new('1.22')
      expect(Version.new('1.23')).to be > Version.new('1.4')

      expect(Version.new('1.23.3')).to be > Version.new('1.4.8')
      expect(Version.new('1.22.3')).to be < Version.new('1.23.2')

      expect(Version.new('1.22.0.3')).to be < Version.new('1.23.0.2')
      expect(Version.new('2.22.0.3')).to be > Version.new('1.23.0.2')
    end

    it 'correctly uses operator ==' do
      expect(Version.new('1.1.0') == Version.new('1.1')).to be true
      expect(Version.new('0.1') == Version.new('1')).to be false
      expect(Version.new('1') == Version.new('1.0.0.0.0')).to be true
      expect(Version.new('1') <=> Version.new('2')).to eq -1
    end

    it 'implements <= and >=' do
      expect(Version.new('1.23')).to be >= Version.new('1.22')
      expect(Version.new('1.23')).to be >= Version.new('1.23')
      expect(Version.new('1.23')).to_not be >= Version.new('1.24')

      expect(Version.new('1.23')).to be <= Version.new('1.24')
      expect(Version.new('1.23')).to be <= Version.new('1.23')
      expect(Version.new('1.23')).to_not be <= Version.new('1.21')
    end
  end

  describe '#to_s' do
    it 'converts properly to string' do
      expect(Version.new('1.1.0').to_s).to eq '1.1'
      expect(Version.new('1.1.0.0.0.0').to_s).to eq '1.1'
      expect(Version.new('25.12.0.2').to_s).to eq '25.12.0.2'
      expect(Version.new('0.5').to_s).to eq '0.5'
    end
  end

  describe '#components' do
    it 'returns components' do
      expect(Version.new('1.22.0').components).to eq [1, 22]
      expect(Version.new('2.2.2').components).to eq [2, 2, 2]
    end

    it 'returns selected number of components' do
      expect(Version.new('1.3.5').components(2)).to eq [1, 3]
      expect(Version.new('1.1').components(4)).to eq [1, 1, 0, 0]
    end

    it 'doesnt change the initial object' do
      object = Version.new('1.3.5')
      array = object.components
      array.reverse!
      expect(object.components).to eq [1, 3, 5]
    end
  end

  describe 'Range' do
    describe '#include?' do
      it 'checks range' do
        object = Version::Range.new(Version.new('1'), Version.new('2'))
        expect(object.include?(Version.new('1.5'))).to be true
        expect(object.include?(Version.new('1.9'))).to be true
        expect(object.include?(Version.new('2'))).to be false
        expect(object.include?(Version.new('1'))).to be true
        expect(object.include?(Version.new('0.9'))).to be false
        expect(object.include?(Version.new('1.6.8'))).to be true
      end
    end

    describe '#to_a' do
      it 'contains the first version' do
        range = Version::Range.new(Version.new('1.2.3'), Version.new('2.3.4'))
        array = range.to_a
        expect(array.first).to eq('1.2.3')
      end
      it 'doesnt contain the last version' do
        range = Version::Range.new(Version.new('1.2.3'), Version.new('2.3.4'))
        array = range.to_a
        expect(array.last).to_not eq('2.3.4')
        expect(array.last).to eq('2.3.3')
      end

      it 'generates all versions' do
        result = ['1.1', '1.1.1', '1.1.2', '1.1.3', '1.1.4', '1.1.5', '1.1.6']
        expect(Version::Range.new('1.1.0', '1.1.7').to_a).to eq result

        expect(Version::Range.new('1.3.5', '1.3.5').to_a).to eq []

        result = ['2.9.7', '2.9.8', '2.9.9', '3']
        expect(Version::Range.new('2.9.7', '3.0.1').to_a).to eq result

        object = Version::Range.new(Version.new('1.2.9'), Version.new('1.3.1'))
        expect(object.to_a).to eq ['1.2.9', '1.3.0']
      end
    end
  end
end
