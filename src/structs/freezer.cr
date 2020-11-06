module Brrr
  struct FreezerData
    property folder : Path
    property entries : Array(Brrr::Package)

    def initialize(@folder : Path, @entries : Array(Brrr::Package))
    end
  end
end
