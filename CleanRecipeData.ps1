$recipes = Get-ChildItem -Path "C:\Users\$ENV:USERNAME\Desktop\Recipes\*.xml"
$recipesTable = @()
foreach($r in $recipes){
    [xml]$xml = Get-Content $r.FullName
    Write-Output $xml.RECIPES.RECIPE.NAME
    $recipeDetails = New-Object -TypeName PSObject
    $recipeDetails | Add-Member -MemberType NoteProperty -Name Name -Value $xml.RECIPES.RECIPE.NAME
    $recipeDetails | Add-Member -MemberType NoteProperty -Name Type -Value $xml.RECIPES.RECIPE.TYPE
    $recipeDetails | Add-Member -MemberType NoteProperty -Name BatchSize -Value $xml.RECIPES.RECIPE.BATCH_SIZE
    $recipeDetails | Add-Member -MemberType NoteProperty -Name BoilSize -Value $xml.RECIPES.RECIPE.BOIL_SIZE
    $recipeDetails | Add-Member -MemberType NoteProperty -Name PrimaryTemp -Value $xml.RECIPES.RECIPE.PRIMARY_TEMP
    $recipeDetails | Add-Member -MemberType NoteProperty -Name Efficiency -Value $xml.RECIPES.RECIPE.EFFICIENCY
    $recipeDetails | Add-Member -MemberType NoteProperty -Name EstColor -Value $xml.RECIPES.RECIPE.EST_COLOR
    $recipeDetails | Add-Member -MemberType NoteProperty -Name EstABV -Value $xml.RECIPES.RECIPE.EST_ABV
    $recipeDetails | Add-Member -MemberType NoteProperty -Name EstOG -Value $xml.RECIPES.RECIPE.EST_OG
    $recipeDetails | Add-Member -MemberType NoteProperty -Name EstFG -Value $xml.RECIPES.RECIPE.EST_FG
    $recipeDetails | Add-Member -MemberType NoteProperty -Name Style -Value $xml.RECIPES.RECIPE.STYLE.NAME
    $recipeDetails | Add-Member -MemberType NoteProperty -Name IBU -Value $xml.RECIPES.RECIPE.IBU
    $recipeDetails | Add-Member -MemberType NoteProperty -Name BoilTime -Value $xml.RECIPES.RECIPE.BOIL_TIME
    $recipeDetails | Add-Member -MemberType NoteProperty -Name Rating -Value $xml.RECIPES.RECIPE.rating
    $recipeDetails | Add-Member -MemberType NoteProperty -Name NumRatings -Value $xml.RECIPES.RECIPE.numRatings
    $recipeDetails | Add-Member -MemberType NoteProperty -Name NumBrews -Value $xml.RECIPES.RECIPE.numBrews
    foreach($fermentable in $xml.RECIPES.RECIPE.FERMENTABLES.FERMENTABLE)
    {
        try{
            $recipeDetails | Add-Member -MemberType NoteProperty -Name "$($fermentable.NAME)-$($fermentable.TYPE)-$($fermentable.ADD_AFTER_BOIL)" -Value $fermentable.AMOUNT -ErrorAction Stop
        }catch{
            $recipeDetails | Add-Member -MemberType NoteProperty -Name "$($fermentable.NAME)-$($fermentable.TYPE)-$($fermentable.ADD_AFTER_BOIL)-2" -Value $fermentable.AMOUNT
        }
    }
    foreach($hop in $xml.RECIPES.RECIPE.HOPS.HOP)
    {
        try{
            $recipeDetails | Add-Member -MemberType NoteProperty -Name "$($hop.NAME)-$($hop.USER_HOP_USE)-$($hop.TIME)" -Value $hop.AMOUNT -ErrorAction Stop
        }catch{
            try{ 
                $recipeDetails | Add-Member -MemberType NoteProperty -Name "$($hop.NAME)-$($hop.USER_HOP_USE)-$($hop.TIME)-2" -Value $hop.AMOUNT -ErrorAction Stop
            }catch{
                $recipeDetails | Add-Member -MemberType NoteProperty -Name "$($hop.NAME)-$($hop.USER_HOP_USE)-$($hop.TIME)-3" -Value $hop.AMOUNT
            }
        }
    }
    foreach($misc in $xml.RECIPES.RECIPE.MISCS.MISC)
    {
        try{
            $recipeDetails | Add-Member -MemberType NoteProperty -Name "$($misc.NAME)-$($misc.TYPE)-$($misc.USE)-$($misc.TIME)" -Value $misc.AMOUNT -ErrorAction Stop
        }catch{
            $recipeDetails | Add-Member -MemberType NoteProperty -Name "$($misc.NAME)-$($misc.TYPE)-$($misc.USE)-$($misc.TIME)-2" -Value $misc.AMOUNT
        }
    }
    foreach($yeast in $xml.RECIPES.RECIPE.YEASTS.YEAST)
    {
        try{
            $recipeDetails | Add-Member -MemberType NoteProperty -Name "$($yeast.LABORATORY)-$($yeast.PRODUCT_ID)-$($yeast.FORM)-$($yeast.TYPE)" -Value $yeast.AMOUNT -ErrorAction Stop
        }catch{
            $recipeDetails | Add-Member -MemberType NoteProperty -Name "$($yeast.LABORATORY)-$($yeast.PRODUCT_ID)-$($yeast.FORM)-$($yeast.TYPE)-2" -Value $yeast.AMOUNT
        }
    }
    $recipesTable += $recipeDetails
}
$recipesTable | Export-Csv "C:\Users\$ENV:USERNAME\Desktop\Recipes\AggregateData.csv"
