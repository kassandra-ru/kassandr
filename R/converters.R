#' Converts I_ipc file from rosstat to tibble
#'
#' Converts I_ipc file from rosstat to tibble
#'
#' Converts I_ipc file from rosstat to tibble
#'
#' @param path_to_source name of the original I_ipc.xls file
#' @param access_date date of access is appended to every observation
#' @param sheet number of sheet, 1 by default
#'
#' @return tibble
#' @export
#' @examples
#' \donttest{
#' # 2020-11-04: Access denied
#' # https://rosstat.gov.ru/storage/mediabank/jRjVxbDx/i_ipc.xlsx
#' # cpi = convert_i_ipc_xlsx()
#' }
convert_i_ipc_xlsx = function(path_to_source = "https://rosstat.gov.ru/storage/mediabank/HOKNtZra/i_ipc.xlsx",
                               access_date = Sys.Date(), sheet = 1) {
  data = rio::import(path_to_source, sheet = sheet)

  data = data[5:16, -1]
  data = tidyr::gather(data, year, value)
  data = dplyr::select(data, -year)
  cpi_ts = stats::ts(data$value, start = c(1991, 1), freq = 12)
  cpi_infl = tsibble::as_tsibble(cpi_ts) %>% stats::na.omit() %>% dplyr::rename(date = index, cpi = value)

  data_tsibble = dplyr::mutate(cpi_infl, access_date = access_date)
  check_conversion(data_tsibble)

  return(data_tsibble)
}



#' Converts tab5a file from rosstat to tibble
#'
#' Converts tab5a file from rosstat to tibble
#'
#' Converts tab5a file from rosstat to tibble.
#' The structure is similar to tab6b.
#'
#' @param path_to_source name of the original tab5a.xls file
#' @param access_date date of access is appended to every observation
#' @param sheet number of sheet, 1 by default
#'
#' @return tibble
#' @export
#' @examples
#' \donttest{
#' tab5a = convert_tab5a_xls()
#' }
convert_tab5a_xls = function(path_to_source = "http://www.gks.ru/free_doc/new_site/vvp/kv/tab5a.xls",
                              access_date = Sys.Date(), sheet = 1) {
  data = rio::import(path_to_source, sheet = sheet)

  data_vector = t(data[6, ]) %>% stats::na.omit() %>% as.numeric()

  data_ts = stats::ts(data_vector, start = c(2011, 1), freq = 4)
  data_tsibble = tsibble::as_tsibble(data_ts) %>% dplyr::rename(date = index, gdp_current_price = value)

  data_tsibble = dplyr::mutate(data_tsibble, access_date = access_date)
  check_conversion(data_tsibble)

  return(data_tsibble)
}


#' Converts tab6b file from rosstat to tibble
#'
#' Converts tab6b file from rosstat to tibble
#'
#' Converts tab6b file from rosstat to tibble.
#' The structure is similar to tab5a.
#'
#' @param path_to_source name of the original tab6b.xls file
#' @param access_date date of access is appended to every observation
#' @param sheet number of sheet, 1 by default
#'
#' @return tibble
#' @export
#' @examples
#' \donttest{
#' tab6b = convert_tab6b_xls()
#' }
convert_tab6b_xls = function(path_to_source = "http://www.gks.ru/free_doc/new_site/vvp/kv/tab6b.xls",
                              access_date = Sys.Date(), sheet = 1) {
  data = rio::import(path_to_source, sheet = sheet)


  # simple choice of 4th or 5th line:
  data_vector_line_4 = t(data[4, ]) %>% stats::na.omit() %>% as.numeric()
  data_vector_line_5 = t(data[5, ]) %>% stats::na.omit() %>% as.numeric()
  if (length(data_vector_line_5) > length(data_vector_line_4)) {
    data_vector = data_vector_line_5
  } else {
    data_vector = data_vector_line_4
  }

  data_ts = stats::ts(data_vector, start = c(2011, 1), freq = 4)
  data_tsibble = tsibble::as_tsibble(data_ts) %>% dplyr::rename(date = index, gdp_2016_price = value)

  data_tsibble = dplyr::mutate(data_tsibble, access_date = access_date)
  check_conversion(data_tsibble)

  return(data_tsibble)
}


#' Converts tab9 file from rosstat to tibble
#'
#' Converts tab9 file from rosstat to tibble
#'
#' Converts tab9 file from rosstat to tibble.
#'
#' @param path_to_source name of the original tab9.xls file
#' @param access_date date of access is appended to every observation
#' @param sheet number of sheet, 1 by default
#'
#' @return tibble
#' @export
#' @examples
#' \donttest{
#' tab9 = convert_tab9_xls()
#' }
convert_tab9_xls = function(path_to_source = "http://www.gks.ru/free_doc/new_site/vvp/kv/tab9.xls",
                             access_date = Sys.Date(), sheet = 1) {
  data = rio::import(path_to_source, sheet = sheet)

  data_vector = t(data[4, ]) %>% stats::na.omit() %>% as.numeric()

  gdp_deflator = stats::ts(data_vector, start = c(1996, 1), freq = 4)
  gdp_deflator = tsibble::as_tsibble(gdp_deflator) %>% dplyr::rename(date = index, deflator_gdp_early = value)

  data_tsibble = dplyr::mutate(gdp_deflator, access_date = access_date)
  check_conversion(data_tsibble)
  return(data_tsibble)
}



#' Converts tab9a file from rosstat to tibble
#'
#' Converts tab9a file from rosstat to tibble
#'
#' Converts tab9a file from rosstat to tibble.
#'
#' @param path_to_source name of the original tab9a.xls file
#' @param access_date date of access is appended to every observation
#' @param sheet number of sheet, 1 by default
#'
#' @return tibble
#' @export
#' @examples
#' \donttest{
#' tab9a = convert_tab9a_xls()
#' }
convert_tab9a_xls = function(path_to_source = "http://www.gks.ru/free_doc/new_site/vvp/kv/tab9a.xls",
                              access_date = Sys.Date(), sheet = 1) {
  data = rio::import(path_to_source, sheet = sheet)

  data = t(data[5, ]) %>% stats::na.omit() %>% as.numeric()

  gdp_deflator = stats::ts(data, start = c(2012, 1), freq = 4)
  gdp_deflator = tsibble::as_tsibble(gdp_deflator) %>% dplyr::rename(date = index, deflator_gdp = value)

  data_tsibble = dplyr::mutate(gdp_deflator, access_date = access_date)
  check_conversion(data_tsibble)
  return(data_tsibble)
}



#' Converts urov_12kv file from rosstat to tibble
#'
#' Converts urov_12kv file from rosstat to tibble
#'
#' Converts urov_12kv file from rosstat to tibble.
#' The function uses libre office to convert .doc files.
#' So libre office should be installed. And path to libre office should be known by the package.
#' Written by: Vladimir Omelyusik
#'
#' @param path_to_source name of the original urov_12kv.doc file
#' @param access_date date of access is appended to every observation
#'
#' @return tibble
#' @export
#' @examples
#' \donttest{
#' # docxtractr::set_libreoffice_path("/usr/bin/libreoffice")  # ubuntu or macos
#' # Sys.setenv(LD_LIBRARY_PATH = "/usr/lib/libreoffice/program/") # ubuntu protection against libreglo.so not found
#' # docxtractr::set_libreoffice_path("C:/Program Files/LibreOffice/program/soffice.exe")  # windows
#' # urov_12kv = convert_urov_12kv_doc()
#' }
convert_urov_12kv_doc = function(path_to_source =
                                    "http://www.gks.ru/free_doc/new_site/population/urov/urov_12kv.doc",
                                  access_date = Sys.Date()) {
  real_world = docxtractr::read_docx(path_to_source)
  table = docxtractr::docx_extract_tbl(real_world, 2)
  table = as.data.frame(table)
  table = table[-c(1, 2), ] # две строки в начале и всё
  colnames(table) = c("date", "percent_to_period_last_year", "percent_to_last_period")
  table = dplyr::filter(table, !grepl("квартал", date), !grepl("Год", date), !grepl("год", date))

  table$date = lubridate::ymd("2008-01-01") + months(0:(nrow(table) - 1))
  table$access_date = access_date

  table = dplyr::mutate_at(table, dplyr::vars(tidyselect::starts_with("percent")), as_numeric_cyrillic)

  data_tsibble = tsibble::as_tsibble(table, index = date)
  check_conversion(data_tsibble)

  return(data_tsibble)
}


#' Converts 1-nn file from rosstat to tibble
#'
#' Converts 1-nn file from rosstat to tibble
#'
#' Converts 1-nn file from rosstat to tibble.
#' The function uses libre office to convert .doc files.
#' So libre office should be installed. And path to libre office should be known by the package.
#'
#' Probably deprecated, as rosstat started to use xlsx files.
#'
#' Written by: Rifat Enileev
#'
#' @param path_to_source name of the original 1-nn.doc file
#' @param access_date date of access is appended to every observation
#'
#' @return tibble
#' @export
#' @examples
#' \donttest{
#' # docxtractr::set_libreoffice_path("/usr/bin/libreoffice")  # ubuntu or macos
#' # Sys.setenv(LD_LIBRARY_PATH = "/usr/lib/libreoffice/program/") # ubuntu protection against libreglo.so not found
#' # docxtractr::set_libreoffice_path("C:/Program Files/LibreOffice/program/soffice.exe")  # windows
#' # one = convert_1_nn_doc()
#' # one = convert_1_nn_doc("http://www.gks.ru/bgd/regl/b18_02/IssWWW.exe/Stg/d010/1-08.doc")
#' # two = convert_1_nn_doc("http://www.gks.ru/bgd/regl/b18_02/IssWWW.exe/Stg/d010/1-03.doc")
#' # three = convert_1_nn_doc("http://www.gks.ru/bgd/regl/b18_02/IssWWW.exe/Stg/d010/1-11.doc")
#' }
convert_1_nn_doc = function(path_to_source =
                               "http://www.gks.ru/bgd/regl/b18_02/IssWWW.exe/Stg/d010/1-08.doc",
                             access_date = Sys.Date()) {

  .Deprecated("convert_1_nn_xlsx")

  tbl = docxtractr::read_docx(path_to_source)
  table_1 = docxtractr::docx_extract_tbl(tbl,
    tbl_number = 1, header = TRUE,
    preserve = FALSE, trim = FALSE
  )



  ncols = ncol(table_1)
  if (ncols == 18) {
    colnames(table_1) = c(
      "year", "yearly", "i", "ii", "iii", "iv", "jan", "feb", "mar", "apr",
      "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"
    )
  } else if (ncols == 13) {
    colnames(table_1) = c(
      "year", "dec", "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug",
      "sep", "oct", "nov"
    )
    table_1 = table_1[c(1, 3:13, 2)]
  } else {
    stop("Wrong number of columns in parsed doc: ", path_to_source)
  }

  # try to guess table id :)
  id_column = dplyr::select(table_1, year) %>% dplyr::filter(stringr::str_count(year) > 10)
  id_guess = dplyr::pull(id_column, year)[1]
  variable_name = dplyr::case_when(
    stringr::str_detect(id_guess, "Dwelling put in place") ~ "construction",
    stringr::str_detect(id_guess, "Agriculture production index") ~ "agriculture",
    stringr::str_detect(id_guess, "consolidated budget") ~ "budget",
    TRUE ~ "value"
  )


  table_1 = subset(table_1, year >= 1999, select = c(
    "jan", "feb", "mar", "apr", "may", "jun",
    "jul", "aug", "sep", "oct", "nov", "dec"
  ))

  table_1$jan = sub(",", ".", table_1$jan, fixed = TRUE)
  table_1$feb = sub(",", ".", table_1$feb, fixed = TRUE)
  table_1$mar = sub(",", ".", table_1$mar, fixed = TRUE)
  table_1$apr = sub(",", ".", table_1$apr, fixed = TRUE)
  table_1$may = sub(",", ".", table_1$may, fixed = TRUE)
  table_1$jun = sub(",", ".", table_1$jun, fixed = TRUE)
  table_1$jul = sub(",", ".", table_1$jul, fixed = TRUE)
  table_1$aug = sub(",", ".", table_1$aug, fixed = TRUE)
  table_1$sep = sub(",", ".", table_1$sep, fixed = TRUE)
  table_1$oct = sub(",", ".", table_1$oct, fixed = TRUE)
  table_1$nov = sub(",", ".", table_1$nov, fixed = TRUE)
  table_1$dec = sub(",", ".", table_1$dec, fixed = TRUE)

  table = dplyr::mutate_all(table_1, function(x) as.numeric(as.character(x))) %>% t() %>% as.data.frame()
  table = tidyr::gather(table)[2]
  table[table == ""] = NA
  table = stats::na.omit(table)

  data_ts = stats::ts(table, start = c(1999, 1), freq = 12)
  data_tsibble = tsibble::as_tsibble(data_ts) %>% dplyr::rename(date = index, !!variable_name := value)
  data_tsibble = dplyr::mutate(data_tsibble, access_date = access_date)
  check_conversion(data_tsibble)

  return(data_tsibble)
}




#' Converts 1-nn xlsx file from rosstat to tibble
#'
#' Converts 1-nn xlsx file from rosstat to tibble
#'
#' Converts 1-nn xlsx file from rosstat to tibble.
#' Written by: Rifat Enileev
#'
#' @param path_to_source name of the original 1-nn.doc file
#' @param access_date date of access is appended to every observation
#' @param sheet number of sheet, 1 by default
#'
#' @return tibble
#' @export
#' @examples
#' \donttest{
#' one = convert_1_nn_xlsx("https://www.gks.ru/bgd/regl/b20_02/IssWWW.exe/Stg/d010/1-07.xlsx")
#' two = convert_1_nn_xlsx("https://www.gks.ru/bgd/regl/b20_02/IssWWW.exe/Stg/d010/1-03.xlsx")
#' three = convert_1_nn_xlsx("https://www.gks.ru/bgd/regl/b20_02/IssWWW.exe/Stg/d010/1-11.xlsx")
#' }
convert_1_nn_xlsx = function(
  path_to_source = "https://www.gks.ru/bgd/regl/b20_02/IssWWW.exe/Stg/d010/1-11.xlsx",
  access_date = Sys.Date(), sheet = 1) {

  table_1 = rio::import(path_to_source, skip = 1, sheet = sheet)

  ### pattern recognition until which we subset
  pattern = '/ percent of'
  id_untill = which(stringr::str_detect(table_1$...1, pattern))[1]

  if (id_untill >= 8){
    table_1 = table_1[1:(id_untill-2),]
  }


  ncols = ncol(table_1)
  if (ncols == 18) {
    colnames(table_1) = c(
      "year", "yearly", "i", "ii", "iii", "iv", "jan", "feb", "mar", "apr",
      "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"
    )
  } else if (ncols == 13) {
    colnames(table_1) = c(
      "year", "dec", "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug",
      "sep", "oct", "nov"
    )
    table_1 = table_1[c(1, 3:13, 2)]
  } else {
    stop("Wrong number of columns in parsed doc: ", path_to_source)
  }

  # try to guess table id :)
  id_column = dplyr::select(table_1, year) %>% dplyr::filter(stringr::str_count(year) > 10)
  id_guess = dplyr::pull(id_column, year)[2]
  variable_name = dplyr::case_when(
    stringr::str_detect(id_guess, "construction activity") ~ "constr_vol_cur_price",
    stringr::str_detect(id_guess, "Agricultural production index") ~ "agriculture",
    stringr::str_detect(id_guess, "consolidated budget") ~ "budget",
    stringr::str_detect(id_guess, "buildings commissioned") ~ "constr_total_area",
    TRUE ~ "value"
  )

  table_1 = subset(table_1, year >= 1999, select = c(
    "jan", "feb", "mar", "apr", "may", "jun",
    "jul", "aug", "sep", "oct", "nov", "dec"
  ))

  table = dplyr::mutate_all(table_1, function(x) as.numeric(as.character(x))) %>% t() %>% as.data.frame()
  table = tidyr::gather(table)[2]
  table[table == ""] = NA
  table = stats::na.omit(table)

  data_ts = stats::ts(table, start = c(1999, 1), freq = 12)
  data_tsibble = tsibble::as_tsibble(data_ts) %>% dplyr::rename(date = index, !!variable_name := value)
  data_tsibble = dplyr::mutate(data_tsibble, access_date = access_date)
  check_conversion(data_tsibble)

  return(data_tsibble)
}







#' Converts m2-m2_sa file from rosstat to tibble
#'
#' Converts m2-m2_sa file from rosstat to tibble
#'
#' Converts m2-m2_sa file from rosstat to tibble.
#' Written by: Petr Garmider
#'
#' @param path_to_source name of the original m2-m2_sa.xlsx file
#' @param access_date date of access is appended to every observation
#' @param sheet number of sheet, 1 by default
#'
#' @return tibble
#' @export
#' @examples
#' \donttest{
#' m2sa = convert_m2_m2_sa_xlsx()
#' }
convert_m2_m2_sa_xlsx = function(path_to_source =
                                    "http://www.cbr.ru/vfs/statistics/credit_statistics/M2-M2_SA.xlsx",
                                  access_date = Sys.Date(), sheet = 1) {
  data = rio::import(path_to_source, sheet = sheet)
  data = data.frame(data)
  colnames(data)[3] = "m2sa"

  data_vector = as.numeric(stats::na.omit(t(data$m2sa[2:length(data$m2sa)])))
  data_ts = stats::ts(data_vector, start = c(1995, 7), freq = 12)
  data_tsibble = tsibble::as_tsibble(data_ts) %>% dplyr::rename(date = index, m2sa = value)
  data_tsibble = dplyr::mutate(data_tsibble, access_date = access_date)
  check_conversion(data_tsibble)

  return(data_tsibble)
}




#' Converts ind_okved2 or ind_baza_2018 file from rosstat to tibble
#'
#' Converts ind_okved2 or ind_baza_2018 file from rosstat to tibble
#'
#' Converts ind_okved2 or ind_baza_2018 file from rosstat to tibble.
#' Written by: Nastya Jarkova, Rifat Enileev, etc
#'
#' @param path_to_source name of the original ind_okved2.xlsx file
#' @param access_date date of access is appended to every observation
#' @param sheet number of sheet, 1 by default
#'
#' @return tibble
#' @export
#' @examples
#' \donttest{
#' # ind = convert_ind_okved2_xlsx()
#' # old link http://www.gks.ru/storage/mediabank/ind_okved2(1).xlsx
#' # old link https://gks.ru/storage/mediabank/ind-baza-2018.xlsx
#' # old link https://rosstat.gov.ru/storage/mediabank/YMKvI51h/ind_baza-2018.xlsx
#' # new http://www.gks.ru/free_doc/new_site/business/prom/ind_okved2.xlsx
#' # new https://rosstat.gov.ru/storage/mediabank/6CWGi6WR/ind_baza-2018.xlsx
#' }
#'
convert_ind_okved2_xlsx = function(path_to_source =
                                      "http://www.gks.ru/free_doc/new_site/business/prom/ind_okved2.xlsx",
                                    access_date = Sys.Date(), sheet = 1) {

  # .Deprecated("convert_ind_okved2_xls")

  indprod = rio::import(path_to_source, skip = 2, sheet = sheet)
  indprod_vector = as.vector(t(indprod[2, 3:ncol(indprod)]))

  # automatic date detection
  # column_names = colnames(indprod)[3:ncol(indprod)]
  # month_year = column_names %>% stringr::str_extract("^([а-я]* [0-9]*)")
  # dates_text = paste0("01 ", month_year)
  # dates = lubridate::dmy(month_to_genetivus(dates_text))

  indprod_ts = stats::ts(indprod_vector, start = c(2013, 1), frequency = 12)
  indprod_tsibble = tsibble::as_tsibble(indprod_ts)
  indprod_tsibble = dplyr::rename(indprod_tsibble, date = index, ind_prod = value)
  indprod_tsibble = dplyr::mutate(indprod_tsibble, access_date = access_date)
  check_conversion(indprod_tsibble)
  return(indprod_tsibble)
}

#' Converts one sheet of ind-baza-2018.xlsx or Ind_sub-2018.xls file from rosstat to tibble
#'
#' Written by: Vladimir Omelyusik
#'
#' @param path_to_source name of the original ind_okved2.xlsx file
#' @param access_date date of access is appended to every observation
#' @param sheet number of sheet
#'
#' @return tibble
#' @export
#' @examples
#' \donttest{
#' # ind = convert_ind_okved2_xls()
#' # new link https://rosstat.gov.ru/storage/mediabank/BYkjy3Bn/Ind_sub-2018.xls
#' # new link (26 Dec 2021): https://rosstat.gov.ru/storage/mediabank/ind_sub_2018.xls
#' }
#'
convert_ind_okved2_xls_one_sheet = function(path_to_source =
                                  "https://rosstat.gov.ru/storage/mediabank/ind_sub_2018.xls",
                                  access_date = Sys.Date(), sheet = 1, variable_name = 'ind_prod') {

  # data
  indprod_data = rio::import(path_to_source, skip = 2, sheet = sheet)
  indprod_vector = t(indprod_data[2, 2:ncol(indprod_data)])

  # automatic date detection
  # @DEPRECATED
  #date_string = rownames(indprod_vector)[1]
  #date_parts = stringr::str_match(date_string, '^([а-яА-я]+) ([0-9]+)')
  #first_obs_year = as.numeric(date_parts[3])
  #first_obs_month = get_month(date_parts[2])
  
  year_string = substr(rownames(indprod_vector)[1], 1, 4)
  first_obs_year = as.numeric(year_string)
  first_obs_month = get_month(indprod_data[1, 2])

  # create series
  indprod_ts = stats::ts(indprod_vector,
                        start = c(first_obs_year, first_obs_month), frequency = 12)

  # create tsibble
  indprod_tsibble = tsibble::as_tsibble(indprod_ts)
  indprod_tsibble = dplyr::rename(indprod_tsibble, date = index,
                                  !!variable_name := value)
  indprod_tsibble = dplyr::mutate(indprod_tsibble, access_date = access_date)

  check_conversion(indprod_tsibble)
  return(indprod_tsibble)
}


#' Converts ind-baza-2018.xlsx or Ind_sub-2018.xls file from rosstat to tibble
#'
#' @param path_to_source name of the original ind_okved2.xlsx file
#' @param access_date date of access is appended to every observation
#'
#' @return tibble
#' @export
#' @examples
#' \donttest{
#' # ind = convert_ind_okved2_xls()
#' # new link https://rosstat.gov.ru/storage/mediabank/BYkjy3Bn/Ind_sub-2018.xls
#' # new link (26 Dec 2021): https://rosstat.gov.ru/storage/mediabank/ind_sub_2018.xls
#' }
#'
convert_ind_okved2_xls = function(path_to_source =
                                              "https://rosstat.gov.ru/storage/mediabank/ind_sub_2018.xls",
                                            access_date = Sys.Date()) {

  sheet_1 = convert_ind_okved2_xls_one_sheet(path_to_source, access_date, sheet = 3,
                                             variable_name = 'ind_prod_perc_prev_month')
  sheet_2 = convert_ind_okved2_xls_one_sheet(path_to_source, access_date, sheet = 1,
                                             variable_name = 'ind_prod_perc_corresp_month')

  indprod_tsibble = dplyr::full_join(sheet_1, sheet_2, by = c('date', 'access_date'))

  check_conversion(indprod_tsibble)
  return(indprod_tsibble)
}







detect_date = function(indprod) {
  start_month = get_month(indprod[1, 2])
  start_year = colnames(indprod)[2]
  start_year = as.integer(substr(start_year, 1, 4))
  return(c(start_year, start_month))
}

get_month = function(month) {
  months = c("январь", "февраль", "март", "апрель", "май", "июнь", "июль", "август", "сентябрь",
             "октябрь", "ноябрь", "декабрь")
  return(which(months == month))
}


#' Converts trade.xls file from cbr to tibble
#'
#' Converts trade.xls file from cbr to tibble
#'
#' Converts trade.xls file from cbr to tibble.
#' Written by: Maxim Alekseev
#'
#' @param path_to_source name of the original trade.xls file
#' @param access_date date of access is appended to every observation
#' @param sheet number of sheet, 1 by default
#'
#' @return tibble
#' @export
#' @examples
#' \donttest{
#' trade = convert_trade_xls()
#' }
convert_trade_xls = function(path_to_source =
                                "https://www.cbr.ru/vfs/statistics/credit_statistics/trade/trade.xls",
                              access_date = Sys.Date(), sheet = 1) {
  data = rio::import(path_to_source, sheet = sheet)
  colnames(data)[c(1, 2, 8)] = c("date", "import", "export")
  namelist = c(
    "январь", "февраль", "март", "апрель", "май", "июнь", "июль",
    "август", "сентябрь", "октябрь", "ноябрь", "декабрь"
  )
  data = dplyr::filter(data, date %in% namelist)
  data_ts = dplyr::select(data, import, export) %>% stats::ts(start = c(1997, 1), freq = 12)
  data_tsibble = tsibble::as_tsibble(data_ts, pivot_longer = FALSE) %>% dplyr::rename(date = index)
  data_tsibble = dplyr::mutate(data_tsibble, access_date = access_date)
  check_conversion(data_tsibble)
  return(data_tsibble)
}





#' Converts tab2.29.xls file from cbr to tibble
#'
#' Converts tab2.29.xls file from cbr to tibble
#'
#' Converts tab2.29.xls file from cbr to tibble.
#' Written by: Maxim Alekseev
#'
#' @param path_to_source name of the original tab2.29.xls file
#' @param access_date date of access is appended to every observation
#' @param sheet number of sheet, 1 by default
#'
#' @return tibble
#' @export
#' @examples
#' # no yet - needs rar extraction!
convert_tab229_xls = function(path_to_source =
                                 "http://www.gks.ru/free_doc/doc_2018/bul_dr/trud/ors-2018-3kv.rar",
                               access_date = Sys.Date(), sheet = 1) {
  # here we need rar extraction !!!!

  data = rio::import(path_to_source, sheet = sheet)
  data_vector = data[4:24, 5] # WILL WORK IN THE FUTURE????
  data_ts = stats::ts(data_vector, start = c(2017, 1), freq = 12)
  data_tsibble = tsibble::as_tsibble(data_ts)
  data_tsibble = dplyr::mutate(data_tsibble, access_date = access_date)
  check_conversion(data_tsibble)
  return(data_tsibble)
}




#' Parse lending rates from cbr
#'
#' Parse lending rates from cbr
#'
#' Parse lending rates from cbr
#' Written by Nastya Jarkova
#'
#' @param access_date date of access is appended to every observation
#' @param path_to_source name of the original html
#' @return tsibble
#' @export
#' @examples
#' \donttest{
#' lend_rate = convert_lendrate()
#' }
convert_lendrate = function(path_to_source = "http://www.cbr.ru/hd_base/mkr/mkr_monthes/",
                             access_date = Sys.Date()) {
  lendrate = path_to_source %>%
    xml2::read_html() %>%
    rvest::html_table()


  # observations are stored in reverse chronological order :)
  lendrate = lendrate[[1]] %>% dplyr::as_tibble() %>% dplyr::arrange(-dplyr::row_number())

  colnames(lendrate) = c("date", "dur_1_day", "dur_2_7_days", "dur_8_30_days", "dur_31_90_days", "dur_91_180_days", "dur_181_plus_days")


  lendrate = dplyr::mutate_at(lendrate, dplyr::vars(dplyr::starts_with("dur")), ~ as_numeric_cyrillic(.))

  # we convert "сентябрь 2001" to "2001-09-01"
  # but dmy wants "мая" and not "май"
  lendrate = dplyr::mutate(lendrate,
    date = tsibble::yearmonth(lubridate::ymd("2000-08-01") + months(0:(nrow(lendrate) - 1))),
    access_date = access_date
  )

  lendrate_tsibble = tsibble::as_tsibble(lendrate, index = "date")
  check_conversion(lendrate_tsibble)
  return(lendrate_tsibble)
}



#' Parse reserves data from cbr
#'
#' Parse reserves data from cbr
#'
#' Parse reserves data from cbr
#' Written by Petr Garmider
#'
#' @param access_date date of access is appended to every observation
#' @param path_to_source name of the original html
#' @return tsibble
#' @export
#' @examples
#' \donttest{
#' reserves = convert_reserves()
#' }
convert_reserves = function(path_to_source = "http://www.cbr.ru/hd_base/mrrf/mrrf_m/",
                             access_date = Sys.Date()) {
  nfa_cb = path_to_source %>%
    xml2::read_html() %>%
    # rvest::html_nodes(xpath = '//*[@id="content"]/table') %>%
    rvest::html_table(fill = TRUE, head = NA)

  nfa_cb = nfa_cb[[1]]

  colnames(nfa_cb) = c("date", "in_res", "nfa_cb", "for_cur", "sdr", "mvf_pos", "mon_gold")

  nfa_cb = nfa_cb[-(1:2), ]
  nfa_cb = dplyr::mutate(nfa_cb, date = tsibble::yearmonth(lubridate::dmy(date)))
  nfa_cb = dplyr::mutate_at(nfa_cb, 2:7, as_numeric_cyrillic)

  data_tsibble = tsibble::as_tsibble(nfa_cb, index = date)
  data_tsibble = dplyr::mutate(data_tsibble, access_date = access_date)
  check_conversion(data_tsibble)
  return(data_tsibble)
}


#' @title Converts Investment file from rosstat to tibble
#' @description Converts Investment file from rosstat to tibble
#' @details Converts Investment file from rosstat to tibble
#' Written by Rifat Eniliev
#' @param path_to_source name of the original 1-06-0.xls file
#' @param access_date date of access is appended to every observation
#' @param sheet number of sheet, 1 by default
#'
#' @return tibble
#' @export
#' @examples
#' \donttest{
#' invest = convert_1_06_0_xlsx()
#' }
#' # convert_1_06_0_xlsx = function(path_to_source = "http://www.gks.ru/bgd/regl/b20_02/IssWWW.exe/Stg/d010/1-06-0.xlsx", access_date = Sys.Date()) {
#' #   data = rio::import(path_to_source)
#' #   data_vector = data[4:23, 3:6]  %>% t() %>% as.vector()
#' #   colnames(data_vector) = NULL
#' #   data_ts = stats::ts(data_vector, start = c(1999, 1), freq = 4)
#' #   data_tsibble = tsibble::as_tsibble(data_ts) %>% dplyr::rename(date = index, invest = value)
#' #   data_tsibble = dplyr::mutate(data_tsibble, access_date = access_date, date = as.Date(date))
#' #   check_conversion(data_tsibble)
#' #   return(data_tsibble)
#' # }
convert_1_06_0_xlsx = function(path_to_source = "http://www.gks.ru/bgd/regl/b20_02/IssWWW.exe/Stg/d010/1-06-0.xlsx",
                                access_date = Sys.Date(), sheet = 1) {
  data = rio::import(path_to_source, sheet = sheet)
  names(data)[1] = "year_col"
  # ниже для уровней
  # ind_lvl_start = which(
  #  data$year_col[c(1:length(data$year_col))] == "1.6. Инвестиции в основной капитал1), млрд рублей")
  # ind_lvl_finish = which(
  #  data$year_col[c(1:length(data$year_col))] == "в % к соответствующему периоду предыдущего года")
  # idx_start = ind_lvl_start + 2
  # idx_finish = ind_lvl_finish - 1

  idx_not_year_start = which(
    data$year_col[c(1:length(data$year_col))] == "/ percent of corresponding period of previous year"
  )
  idx_not_year_finish = which(
    data$year_col[c(1:length(data$year_col))] == "/ percent of previous period"
  )
  idx_start = idx_not_year_start + 1
  idx_finish = idx_not_year_finish - 2

  data_vector = data[idx_start:idx_finish, 3:6] %>% t() %>% as.vector()
  colnames(data_vector) = NULL
  data_vector = stats::na.omit(data_vector)
  data_ts = stats::ts(data_vector, start = c(1999, 1), freq = 4)
  data_tsibble = tsibble::as_tsibble(data_ts)
  data_tsibble = dplyr::mutate(data_tsibble, access_date = access_date)
  data_tsibble = dplyr::rename(data_tsibble, date = index, investment = value)
  check_conversion(data_tsibble)
  return(data_tsibble)
}



#' @title Checks conversion results
#' @description Checks some basic requirements for converted data from raw formats.
#' @details Checks some basic requirements for converted data from raw formats.
#' @param data_tsibble converted time series
#' @return TRUE or will stop with error message
#' @export
#' @examples
#' \donttest{
#' # cpi = convert_i_ipc_xlsx()
#' # check_conversion(cpi)
#' }
check_conversion = function(data_tsibble) {
  if (!"tbl_df" %in% class(data_tsibble)) {
    stop("Class of the converted data does not include 'tbl_df'. Please use 'tibble' or 'tsibble' class.")
  }
  var_names = colnames(data_tsibble)
  if (!"date" %in% var_names) {
    stop("Column names of converted data frame do not contain 'date' field. Please add it or check naming!")
  }
  if (!"access_date" %in% var_names) {
    stop("Column names of converted data frame do not contain 'access_date' field. Please add it or check naming!")
  }
  if ("value" %in% var_names) {
    stop("Column names of converted data frame contain meaningless 'value' field. Please rename it!")
  }
  if (length(var_names) < 3) {
    stop("Less than 3 columns in converted data frame. Should have at least: 'date', 'access_date' and something meaningful :)")
  }
  return(invisible(TRUE))
}

#' @title Changes month name from nominativus to genetivus
#' @description Changes month name from nominativus to genetivus.
#' @details Functions like dmy needs month names in genetivus.
#' @param x string with month names in nominativus
#' @return string with month names in nominativus
#' @export
#' @examples
#' month_to_genetivus("май")
month_to_genetivus = function(x) {
  month_from = c("январь", "февраль", "март", "апрель", "май", "июнь", "июль",
    "август", "сентябрь", "октябрь", "ноябрь", "декабрь")
  month_to = c("января", "февраля", "марта", "апреля", "мая", "июня", "июля",
               "августа", "сентября", "октября", "ноября", "декабря")
  for (i in 1:12) {
    x = stringr::str_replace(x, month_from[i], month_to[i])
  }
  return(x)
}



