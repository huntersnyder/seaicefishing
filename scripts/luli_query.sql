SELECT
    i.indh_nr,
    i.indhandl_dato,
    to_char(i.indhandl_dato, 'yyyy') year,
    i.landingsdato,
    i.saelger_jur_pers_id,
    i.koeber_jur_pers_id,
    get_idv.idv_primaer_by_bygd_gl(i.koeber_jur_pers_id, i.indhandl_dato) koeber_by_bygd,
    get_idv.idv_primaer_postnr(i.koeber_jur_pers_id, i.indhandl_dato) koeber_postnr,
    get_idv.idv_primaer_by_bygd_gl(i.saelger_jur_pers_id, i.indhandl_dato) saelger_by_bygd,
    get_idv.idv_primaer_postnr(i.saelger_jur_pers_id, i.indhandl_dato) saelger_postnr,
    get_ftj.ftj_kategori_type_kode(i.ftj_id, i.indhandl_dato) fartoej_kategori,
    get_ftj.ftj_motor_hk(i.ftj_id, i.indhandl_dato) motor_hk,
    get_ftj.ftj_laengde(i.ftj_id, i.indhandl_dato) ftj_laengde_dangerous --,kt.licensnr
,
    k.kvote_type_kode,
    iv.anvendelse_kode,
    aa.tekst anvendelse_tekst,
    iv.art_kode,
    a.tekst art_dk,
    a.tekst_uk art_uk,
    a.tekst_lt art_latin,
    iv.behgrd_kode,
    iv.maengde --product weight
,
    gflk_select_func.fgetbehgradfaktor(iv.art_kode, iv.behgrd_kode) * iv.maengde lev_vaegt,
    a.indh_antal_tjek_jn,
    antal_individer,
    iv.stoerrelse_kode --size dist. not mandatory
,
    vaerdi,
    fiskeritimer,
    iv.fistrawltype_type,
    (
        SELECT
            ttypeuk
        FROM
            fistrawltype ftt
        WHERE
            ftt.ttype = fistrawltype_type
    ) ttypeuk,
    (
        SELECT
            ttypedk
        FROM
            fistrawltype ftt
        WHERE
            ftt.ttype = fistrawltype_type
    ) ttypedk,
    antal_redskaber,
    breddegrad,
    laengdegrad,
    fangstfelt --feltkode
,
    logbogsnr
FROM
    indhandlinger i
    JOIN indh_varelinier iv ON i.id = iv.indh_id
    JOIN kvote_tildelinger kt ON iv.kvote_tild_id = kt.id
    left outer join kvoter k OB kt.kvoter_id = k.id
    JOIN arter a ON iv.art_kode = a.kode
    LEFT OUTER JOIN art_anvendelser aa ON iv.anvendelse_kode = aa.kode
WHERE
    i.status_kode IN ('OK', 'ADVIS')
    AND (
        i.indhandl_dato BETWEEN TO_DATE ('01012012', 'ddmmyyyy')
        AND TO_DATE ('31122022', 'ddmmyyyy')
    )