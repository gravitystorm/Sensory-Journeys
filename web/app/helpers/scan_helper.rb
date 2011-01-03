module ScanHelper

  def get_step_description(number)

    description = case number
                  when 0 then 'Preparing for upload'
                  when 1 then 'Queued for processing'
                  when 2 then 'Sifting'
                  when 3 then 'Finding needles'
                  when 4 then 'Reading QR code'
                  when 5 then 'Tiling and uploading'
                  when 6 then 'Finished'
                  when 98 then 'We could not read the QR code'
                  when 99 then 'A temporary error has occured'
                  when 100 then ' A permanent error has occured'
                  when 101 then 'We could not read the QR code'
                  else 'dunno'
                  end
    return description
  end
end
