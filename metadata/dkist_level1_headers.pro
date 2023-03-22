;-------------------------------------------------------------
;+
; NAME:
;       dkist_level1_headers
; PURPOSE:
;       extract and organize information from headers of DKIST Level 1 files
; CATEGORY:
; CALLING SEQUENCE:
;       header_info = dkist_level1_headers(filelist)
; INPUTS:
;       filelist = input array of FITS files to process                    in
; KEYWORD PARAMETERS:
;       Keywords:
; OUTPUTS:
;       header_info = structure containing parsed header content        out
; COMMON BLOCKS:
; NOTES:
; MODIFICATION HISTORY:
;       K. Reardon, November 2023
;
;-
;-------------------------------------------------------------

FUNCTION dkist_level1_headers,filelist, header_array=header_array

num_files      = n_elements(filelist)

max_hdr_len    = 1000
header_array   = strarr(max_hdr_len,num_files)
header_lengths = intarr(num_files)

header_array = strarr(max_hdr_len,num_files)
header_lengths = intarr(num_files)
date_obs_str = strarr(num_files)
date_obs_jd  = dblarr(num_files)
instr_name_str = strarr(num_files)

for filenum=0,num_files-1 do begin
    fits_open,filelist[filenum],fcb
    fits_read,fcb,data,header,/header_only
    fits_close,fcb
    header_array[0,filenum] = header
    header_lengths[filenum] = N_ELEMENTS(header)
    date_obs_str[filenum] = sxpar(header,'DATE-BEG')
    date_obs_jd[filenum]  = fits_date_convert(date_obs_str[filenum])
    instr_name_str[filenum] = sxpar(header,'INSTRUME')
endfor

instrument_used = strtrim(instr_name_str[0],2)
print,instrument_used

date_obs_sort = sort(date_obs_jd)
filelist_sorted = filelist[date_obs_sort]
header_array    = header_array[*,date_obs_sort]
header_array = header_array[0:max(header_lengths)-1,*]

coord_info_single = create_struct('NAXIS', 1, $
                                  'NAXIS1', 1, $
                                  'NAXIS2', 1, $
                                  'NAXIS3', 1, $
                                  'WCSNAME', '', $
                                  'WCSAXES', 3, $
                                  'CRVAL1', 1.0, $
                                  'CRVAL2', 1.0, $
                                  'CRVAL3', 1.0, $
                                  'CDELT1', 1.0, $
                                  'CDELT2', 1.0, $
                                  'CDELT3', 1.0, $
                                  'CRPIX1', 1.0, $
                                  'CRPIX2', 1.0, $
                                  'CRPIX3', 1.0, $
                                  'CUNIT1', '', $
                                  'CUNIT2', '', $
                                  'CUNIT3', '', $
                                  'CTYPE1', '', $
                                  'CTYPE2', '', $
                                  'CTYPE3', '', $
                                  'CRDATE1', '', $
                                  'CRDATE2', '', $
                                  'CRDATE3', '', $
                                  'PC1_1', 1.0,  $
                                  'PC1_2', 1.0,  $
                                  'PC2_1', 1.0,  $
                                  'PC2_2', 1.0, $
                                  'DATEREF', '' )
                                 
telescope_info_single = create_struct('ELEV_ANG', 1.0, $
                                      'TAZIMUTH', 1.0, $
                                      'TTBLANGL', 1.0, $
                                      'TTBLTRCK', '', $
                                      'ROTCOMP', '', $
                                      'TELTRACK', '', $
                                      'AO_LOCK', '', $
                                      'LVL0STAT', '', $
                                      'LVL1STAT', '', $
                                      'LVL2STAT', '', $
                                      'LVL3STAT', '', $
                                      'LAMPSTAT', '', $
                                      'LGOSSTAT', '', $
                                      'APERTURE', '', $
                                      'GOSTEMP',  1.0 )

time_info_single = create_struct(  'DATE_BEG', '', $
                                   'DATE_END', '', $
                                   'DATE_BEG_JD', 1.0d, $
                                   'DATE_END_JD', 1.0d,$
                                   'CADENCE', 1.0d )

observation_info_single = create_struct('PROP_ID', '', $
                                        'OBSPR_ID', '', $
                                        'EXPER_ID', '', $
                                        'IP_ID', '', $
                                        'DSP_ID', '', $
                                        'FILE_ID', '', $
                                        'FIDO_CFG', '', $
                                        'IPTASK', '', $
                                        'ATMOS_R0', 1.0, $
                                        'LIGHTLVL', 1.0, $
                                        'WIND_SPD', 1.0, $
                                        'WIND_DIR', 1.0, $
                                        'WS_TEMP', 1.0, $
                                        'WS_HUMID', 1.0, $
                                        'WS_DEWPT', 1.0, $
                                        'WS_PRESS', 1.0 )

exposure_info_single = create_struct('XPOSURE', 1.0, $
                                     'TEXPOSUR', 1.0, $
                                     'NSUMEXP', 1.0, $
                                     'NUMFPA', 1.0, $  ; CAM__013
                                     'CURRFPA', 1.0, $  ; CAM__015
                                     'CAM_FPS', 1.0, $
                                     'CAMERA', '', $
                                     'CAM_ID', '' )

wavelength_info_single = create_struct('WAVEBAND', '', $
                                       'WAVEMIN', 1.0, $
                                       'WAVEMAX', 1.0, $
                                       'WAVEUNIT', 1.0)
    
instrument_info_vbi_single = create_struct('INSTRUME',    '', $
                                           'VBINSTP', 1.0, $
                                           'VBISTP', 1.0, $
                                           'VBISTPAT', '', $
                                           'VBINFRAM', 1.0, $
                                           'VBIFRAM', 1.0, $
                                           'VBIFRIED', 1.0)   ; PAC__011

instrument_info_visp_single = create_struct('INSTRUME',    '', $
                                           'VSPARMPS', 1.0, $
                                           'VSPARMFC', 1.0, $
                                           'VSPGRTAN', 1.0, $
                                           'VSPPOLMD', '', $
                                           'VSPMODID', '', $
                                           'VSPMOD',   '', $
                                           'VSPNUMST', 1.0, $
                                           'VSPSTNUM', 1.0, $
                                           'VSPWID',   1.0, $
                                           'VSPSLTSS', 1.0, $
                                           'VSPNSTP',  1.0, $
                                           'VSPSTP',   1.0, $
                                           'VSPTPOS',  1.0 )   ; PAC__011

help,coord_info_single
coord_info_tags = tag_names(coord_info_single)
coord_num_tags = n_elements(coord_info_tags)
coord_keywords = coord_info_tags

wavelength_info_tags = tag_names(wavelength_info_single)
wavelength_num_tags = n_elements(wavelength_info_tags)
wavelength_keywords = wavelength_info_tags

telescope_info_tags = tag_names(telescope_info_single)
telescope_num_tags = n_elements(telescope_info_tags)
telescope_keywords = telescope_info_tags

exposure_info_tags = tag_names(exposure_info_single)
exposure_num_tags = n_elements(exposure_info_tags)
exposure_keywords = exposure_info_tags

time_info_tags = tag_names(time_info_single)
time_num_tags = n_elements(time_info_tags)
time_keywords = time_info_tags
time_keywords[WHERE(time_info_tags EQ 'DATE_BEG')] = 'DATE-BEG'
time_keywords[WHERE(time_info_tags EQ 'DATE_END')] = 'DATE-END'

instrument_info_vbi_tags = tag_names(instrument_info_vbi_single)
instrument_num_vbi_tags = n_elements(instrument_info_vbi_tags)
instrument_keywords_vbi = instrument_info_vbi_tags

instrument_info_visp_tags = tag_names(instrument_info_visp_single)
instrument_num_visp_tags = n_elements(instrument_info_visp_tags)
instrument_keywords_visp = instrument_info_visp_tags

observation_info_tags = tag_names(observation_info_single)
observation_num_tags = n_elements(observation_info_tags)
observation_keywords = observation_info_tags

header_content_single = create_struct('filename', '', 'directory', '', $
    'time_info', time_info_single,$
    'wcs_info', coord_info_single, $
    'wave_info',wavelength_info_single, $
    'exp_info', exposure_info_single, $
    'obs_info', observation_info_single, $
    'inst_vbi_info',instrument_info_vbi_single, $
    'inst_visp_info',instrument_info_visp_single, $
    'tel_info', telescope_info_single)

header_content = replicate(header_content_single, num_files)

for filenum=0,num_files-1 do begin
    filenumstr = strtrim(filenum,2)
    instrument_type = strtrim(sxpar(header_array[*,filenum],'INSTRUME'),2)
    
    for tag_num = 0,coord_num_tags - 1 do begin
        command_left = 'header_content[' + filenumstr + '].wcs_info.' + coord_info_tags[tag_num] 
        command_right = 'sxpar(header_array[*,' + filenumstr + '],''' + coord_keywords[tag_num] + ''')'  ;'''
        result = execute(command_left + ' = ' + command_right)
    endfor

    for tag_num = 0,wavelength_num_tags - 1 do begin
        command_left = 'header_content[' + filenumstr + '].wave_info.' + wavelength_info_tags[tag_num] 
        command_right = 'sxpar(header_array[*,' + filenumstr + '],''' + wavelength_keywords[tag_num] + ''')'  ;'''
        result = execute(command_left + ' = ' + command_right)
    endfor

    for tag_num = 0,telescope_num_tags - 1 do begin
        command_left = 'header_content[' + filenumstr + '].tel_info.' + telescope_info_tags[tag_num] 
        command_right = 'sxpar(header_array[*,' + filenumstr + '],''' + telescope_keywords[tag_num] + ''')'  ;'''
        result = execute(command_left + ' = ' + command_right)
    endfor

    for tag_num = 0,exposure_num_tags - 1 do begin
        command_left = 'header_content[' + filenumstr + '].exp_info.' + exposure_info_tags[tag_num] 
        command_right = 'sxpar(header_array[*,' + filenumstr + '],''' + exposure_keywords[tag_num] + ''')'  ;'''
        result = execute(command_left + ' = ' + command_right)
    endfor

    for tag_num = 0,time_num_tags - 1 do begin
        command_left = 'header_content[' + filenumstr + '].time_info.' + time_info_tags[tag_num] 
        command_right = 'sxpar(header_array[*,' + filenumstr + '],''' + time_keywords[tag_num] + ''')'  ;'''
        result = execute(command_left + ' = ' + command_right)
    endfor

    if strupcase(instrument_type) EQ 'VBI' then begin
        for tag_num = 0,instrument_num_vbi_tags - 1 do begin
            command_left = 'header_content[' + filenumstr + '].inst_vbi_info.' + instrument_info_vbi_tags[tag_num] 
            command_right = 'sxpar(header_array[*,' + filenumstr + '],''' + instrument_keywords_vbi[tag_num] + ''')'  ;'''
            result = execute(command_left + ' = ' + command_right)
        endfor
    endif 

    if strupcase(instrument_type) EQ 'VISP' then begin
        for tag_num = 0,instrument_num_visp_tags - 1 do begin
            command_left = 'header_content[' + filenumstr + '].inst_visp_info.' + instrument_info_visp_tags[tag_num] 
            command_right = 'sxpar(header_array[*,' + filenumstr + '],''' + instrument_keywords_visp[tag_num] + ''')'  ;'''
            result = execute(command_left + ' = ' + command_right)
        endfor
    endif 

    for tag_num = 0,observation_num_tags - 1 do begin
        command_left = 'header_content[' + filenumstr + '].obs_info.' + observation_info_tags[tag_num] 
        command_right = 'sxpar(header_array[*,' + filenumstr + '],''' + observation_keywords[tag_num] + ''')'  ;'''
        result = execute(command_left + ' = ' + command_right)
    endfor

    ;header_content[filenum].time_info.progstrt_jd = fits_date_convert(header_content[filenum].time_info.progstrt)
    if strlen(header_content[filenum].time_info.date_beg) GE 10 then $
        header_content[filenum].time_info.date_beg_jd = fits_date_convert(header_content[filenum].time_info.date_beg)
    if strlen(header_content[filenum].time_info.date_end) GE 10 then $
        header_content[filenum].time_info.date_end_jd = fits_date_convert(header_content[filenum].time_info.date_end)
    
    header_content[filenum].filename  = filelist_sorted[filenum]
    header_content[filenum].directory = file_dirname(filelist_sorted[filenum], /mark)

endfor

return,header_content

end


