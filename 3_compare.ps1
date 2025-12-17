# TODO fix hardcoding of paths

foreach ($depot in '377161','377162', '377163','377164','377165','377166','377167','377168',
                   '393880','393881','393882','393883','393884',
                   '404091',
                   '435870','435871','435872','435873','435874','435875','435876','435877','435878','435879','435880') {
    .\tools\delta-maker.ps1 E:\fallout-4-downgrader-maker\depots\$depot\latest E:\fallout-4-downgrader-maker\depots\$depot\2019 E:\fallout-4-downgrader-maker\depots\$depot\downgrade_2019 E:\fallout-4-downgrader-maker\output2019\$depot.txt
}

foreach ($depot in '377161','377162', '377163','377164','377165','377166','377167','377168',
                   '393880','393881','393882','393883','393884',
                   '404091',
                   '435870','435871','435872','435873','435874','435875','435876','435877','435878','435879','435880') {
    .\tools\delta-maker.ps1 E:\fallout-4-downgrader-maker\depots\$depot\latest E:\fallout-4-downgrader-maker\depots\$depot\2024 E:\fallout-4-downgrader-maker\depots\$depot\downgrade_2024 E:\fallout-4-downgrader-maker\output2024\$depot.txt
}

foreach ($depot in '377161','377162', '377163','377164','377165','377166','377167','377168',
                   '393880','393881','393882','393883','393884',
                   '404091',
                   '435870','435871','435872','435873','435874','435875','435876','435877','435878','435879','435880') {
    .\tools\delta-maker.ps1 E:\fallout-4-downgrader-maker\depots\$depot\latest E:\fallout-4-downgrader-maker\depots\$depot\2025 E:\fallout-4-downgrader-maker\depots\$depot\downgrade_2025 E:\fallout-4-downgrader-maker\output2025\$depot.txt
}
