$urlPre = "https://www.brewersfriend.com/homebrew-recipes/page/"
$urlPost = "?sort=brewed-desc"
$numPages = 43
$recipes = @()
for($i = 0; $i -le $numPages; $i++)
{
    Write-Progress -Activity "Scraping Homebrewers Friend" -Status "Page $($i+1) of $($numPages)" -PercentComplete ((($i+1)/$numPages)*100)
    $WebResponse = Invoke-WebRequest "$urlPre$i$urlPost"
    $recipes += $WebResponse.AllElements | Where {$_.TagName -eq 'a' -and $_.outerHTML -like "*recipetitle*"} | select innerText,href
}
$recipes | Export-Csv -NoTypeInformation -Path C:\Users\nziehnert\Desktop\Recipes.csv
