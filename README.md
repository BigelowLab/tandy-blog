# tandy-blog
Data blog for [Tandy Center for Ocean Forecasting](https://www.bigelow.org/services/ocean-forecasting/)

## General guidelines

Follow this [general guide](https://quarto.org/docs/websites/website-blog.html)  New posts should follow [this guide](https://quarto.org/docs/websites/website-blog.html) which explains about making sub-directories in the `post/` directory. 

### Post naming

Please use the `YYYY-mm-dd_my_post_name` format.

### To code or not to code?

To keep things light weight please do **not** include code in your `index.qmd` unless it is pseudo-code.  If you want to have some code that will generate output to be inlcuded in you post, then please make a separate un-rendered file (like `script.R` or `script.py`).


### An example post directory

```
<tandy-blog>/
  posts/
    2024-09-30_my_cool_post/
      index.qmd   
      script.R
      some_small_data.csv.gz
      some_image.png
      another_image.png
```


## Categories

Let's be judicious in our use of categories (tags really) to facilitate searching by keywords. 


## Programming examples vs tutorials

Tutorials probably belong elsewhere - like [here](https://github.com/BigelowLab/handytandy) - but brief examples are good for here. 
