$recipes = Get-ChildItem -Path "C:\Users\$ENV:Username\Desktop\Recipes\*.xml"
foreach($r in $recipes){
    [xml]$xml = Get-Content $r.FullName
    $nameArray = $r.FullName -split "-"
    $rating = $nameArray[1]
    $numRatings = $nameArray[2]
    $numBrews = $nameArray[3] -replace ".xml",""
    $n1 = $xml.CreateNode("element","rating","")
    $n1.InnerText = $rating
    $n2 = $xml.CreateNode("element","numRatings","")
    $n2.InnerText = $numRatings
    $n3 = $xml.CreateNode("element","numBrews","")
    $n3.InnerText = $numBrews
    $xml.RECIPES.RECIPE.AppendChild($n1)
    $xml.RECIPES.RECIPE.AppendChild($n2)
    $xml.RECIPES.RECIPE.AppendChild($n3)
    $xml.Save($r.FullName)
}
