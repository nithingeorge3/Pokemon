//
//  JSONData.swift
//  Recipes
//
//  Created by Nitin George on 06/03/2025.
//

struct JSONData {
    static let recipeValidJSON = """
{
    "count": 4,
    "results": [
        {
            "id": 1,
            "name": "Pasta",
            "country": "US",
            "thumbnail_url": "https://img.buzzfeed.com/thumbnailer-prod-us-east-1/video-api/assets/281005.jpg",
            "created_at": 1672531200
        },
        {
            "id": 2,
            "name": "Curry",
            "thumbnail_url": "https://img.buzzfeed.com/thumbnailer-prod-us-east-1/45b4efeb5d2c4d29970344ae165615ab/FixedFBFinal.jpg",
                "created_at": 1672531200
        },
        {
            "id": 3,
            "name": "Chicken",
            "country": "US",
            "thumbnail_url": "https://img.buzzfeed.com/thumbnailer-prod-us-east-1/video-api/assets/281005.jpg",
            "created_at": 1672531200
        },
        {
            "id": 4,
            "name": "Beef",
            "country": "US",
            "thumbnail_url": "https://img.buzzfeed.com/thumbnailer-prod-us-east-1/video-api/assets/281005.jpg",
            "created_at": 1672531200
        }
    ]
}
"""
    
    static let recipeEmptyJSON = """
{
    "count": 4,
    "results": [
    ]
}
"""
    
    static let recipeInvalidJSON = """
{
    "count": 4,
    "results": [
        {
            "id": 1,
            "name": Pasta,
            "country": "US",
            "thumbnail_url": "https://img.buzzfeed.com/thumbnailer-prod-us-east-1/video-api/assets/281005.jpg",
            "created_at": 1672531200
        }
    ]
}
"""
}
