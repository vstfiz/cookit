class Recipe {
  String name;
  String chef_name;
  String reference;
  String imageUrl;
  var ingredients = [];
  String chef_dp;
  var recipe = [];

  Recipe(this.name, this.chef_name, this.reference, this.imageUrl,
      this.ingredients, this.chef_dp, this.recipe);

  @override
  String toString() {

    return this.chef_dp+'\n'+this.chef_name+'\n'+this.imageUrl+'\n'+this.name+'\n'+'\n'+this.ingredients[0]+'\n'+this.recipe[0];
  }
}