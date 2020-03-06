$urlPre = "https://www.brewersfriend.com/homebrew/recipe/beerxml1.0/"
$urlPre2 = "https://www.brewersfriend.com"
$recipes = Import-Csv -Path "C:\Users\$ENV:USERNAME\Desktop\Recipes.csv"
for($i = 0; $i -lt $recipes.Count; $i++)
{
    $beerInfo = Invoke-WebRequest "$urlPre2$($recipes[$i].href)"
    $rating = (($beerInfo.ParsedHtml.body.getElementsByTagName("span")) | Where {$_.outerHTML -notlike "*aggregateRating*" -and $_.outerHTML -like "*ratingValue*"}).InnerText
    $numRatings = (($beerInfo.ParsedHtml.body.getElementsByTagName("span")) | Where {$_.outerHTML -notlike "*aggregateRating*" -and $_.outerHTML -like "*reviewCount*"}).InnerText
    $numBrewsRegex = (($beerInfo.ParsedHtml.body.getElementsByClassName("statistic")) | Where {$_.textContent -like "*brews*"}).InnerText -match "(\d+)"
    $numBrews = $Matches[0]
    Write-Progress -Activity "Scraping Recipes" -Status "Recipe $($i+1) of $($recipes.Count)" -PercentComplete ((($i+1)/$recipes.Count)*100)
    $recipeIds = $recipes[$i].href  -match "/homebrew/recipe/view\/([^\/]+)/"
    $recipeId = $Matches[1]
    [xml]$xml = (Invoke-WebRequest "$urlPre$recipeId").Content
    $xml.Save("C:\Users\$ENV:USERNAME\Desktop\Recipes\$recipeId-$rating-$numRatings-$numBrews.xml")
}
