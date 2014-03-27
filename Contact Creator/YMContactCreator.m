//
//  YMContactCreator.m
//  Contact Creator
//
//  Created by Steven Hepting on 12/7/12.
//  Copyright (c) 2012 Yammer. All rights reserved.
//

#import "YMContactCreator.h"
#import "ABContactsHelper.h"
#import "Names.h"
#import "SVProgressHUD.h"
#import "ABStandin.h"
#import "NSArray+Random.h"
#import "PSRandom.h"

const NSString *PSContactGenderMale = @"male";
const NSString *PSContactGenderFemale = @"female";

@implementation YMContactCreator

+ (void)askAndCreateContactsWithCount:(NSInteger)numContacts
{
    if ([ABStandin hasAddressBookAccess:[ABStandin currentAddressBook]]) {
        YMContactCreator *creator = [[YMContactCreator alloc] init];
        [creator createNContacts:numContacts];
        
    }
}

- (NSString *)randomGender
{
    return [@[PSContactGenderMale, PSContactGenderFemale] randomItem];
}

- (NSString *)randomPhoneNumber
{
    int firstTuple = arc4random_uniform(900) + 99;
    int secondTuple = arc4random_uniform(900) + 99;
    int lastTuple = arc4random_uniform(9000) + 999;

    NSString *phoneNumber = [NSString stringWithFormat:@"(%i)%i-%i", firstTuple, secondTuple, lastTuple];
    
    return phoneNumber;
}

- (BOOL)shouldHaveProfile
{
    return arc4random_uniform(100) < 90;
}

- (BOOL)coinFlip
{
    if (arc4random_uniform(2) == 1) {
        return YES;
    } else {
        return NO;
    }
}

- (UIImage *)randomProfileForGender:(NSString *)gender
{
    NSString *imageName;
    if (gender == PSContactGenderFemale) {
        imageName = [@[@"Woman1", @"Woman2", @"Woman3"] randomItem];
    } else {
        imageName = [@[@"Man1", @"Man2", @"Man3"] randomItem];
    }
    
    return [UIImage imageNamed:imageName];
}

- (NSString *)emailWithFirstName:(NSString *)first lastName:(NSString *)last andDomain:(NSString *)domain
{
    NSString *firstName = [first lowercaseString];
    NSString *firstLetter = [firstName substringToIndex:1];
    NSString *lastName = [last lowercaseString];
    
    if ([PSRandom chance:0.4]) {
        return [NSString stringWithFormat:@"%@.%@@%@", firstLetter, lastName, domain];
    } else if ([PSRandom chance:0.5]) {
        return [NSString stringWithFormat:@"%@.%@@%@", firstName, lastName, domain];
    } else {
        return [NSString stringWithFormat:@"%@%@@%@", firstLetter, lastName, domain];
    }
}

- (NSString *)workEmailWithFirst:(NSString *)firstName andLast:(NSString *)lastName
{
    NSString *domain = [[self workDomains] randomItem];
    
    return [self emailWithFirstName:firstName lastName:lastName andDomain:domain];
}

- (NSString *)personalEmailWithFirst:(NSString *)firstName andLast:(NSString *)lastName
{
    NSString *domain = [[self personalDomains] randomItem];
    
    return [self emailWithFirstName:firstName lastName:lastName andDomain:domain];
}

- (void)createNContacts:(NSInteger)n
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"Generating" maskType:SVProgressHUDMaskTypeGradient];
    });
    
    NSArray *mensFirstNames = [self mensFirstNames];
    NSArray *womensFirstNames = [self womensFirstNames];
    NSArray *lastNames = [self lastNames];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"Creating" maskType:SVProgressHUDMaskTypeGradient];
    });
    for (int i = 0; i < n; i++) {
        

        
        // Choose male or female
        NSString *gender = [self randomGender];
        NSArray *namesArray = (gender == PSContactGenderFemale) ? womensFirstNames : mensFirstNames;
        
        // Name
        // Create contact
        ABContact *newContact = [ABContact contact];
        NSString *firstName = [namesArray randomItem];
        NSString *lastName = [lastNames randomItem];
        newContact.firstname = firstName;
        newContact.lastname = lastName;
        
        // Emails
        if ([PSRandom chance:0.8]) {
            NSString *email = [self workEmailWithFirst:firstName andLast:lastName];
            [newContact addEmailItem:email withLabel:kABWorkLabel];
        }
        if ([PSRandom chance:0.8]) {
            NSString *email1 = [self personalEmailWithFirst:firstName andLast:lastName];
            NSString *email2 = [self personalEmailWithFirst:firstName andLast:lastName];
            [newContact addEmailItem:email1 withLabel:kABHomeLabel];
            
            if ([PSRandom chance:0.3]) {
                [newContact addEmailItem:email2 withLabel:kABHomeLabel];
            }
        }
        
        // Profile Picture
        if ([self shouldHaveProfile]) {
            newContact.image = [self randomProfileForGender:gender];
        }
        
        NSLog(@"Saving %@ %@", newContact.firstname, newContact.lastname);
        
        NSError *error;
        BOOL success = [ABContactsHelper addContact:newContact withError:&error];
        if (!success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"Error"];
            });
            NSLog(@"Error: %@", [error localizedDescription]);
            return;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"Saving" maskType:SVProgressHUDMaskTypeGradient];
    });
    
    NSError *saveError;
    BOOL saveSuccess = [ABStandin save:&saveError];
    if (!saveSuccess) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:@"Error"];
        });
        NSLog(@"Error: %@", [saveError localizedDescription]);
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:@"Done"];
    });
    NSLog(@"Done creating.");
}

- (NSArray *)womensFirstNames
{
    return @[@"Christin",  @"Jennifer",  @"Elizabet",  @"Angel",  @"Michelle",  @"Mary",  @"Amy",  @"Kimberly",  @"Milicent",  @"Catherin",  @"Heather",  @"Kelly",  @"Sarah",  @"Nicole",  @"Stephani",  @"Ann",  @"Rebecca",  @"Laura",  @"Tracy",  @"Staci",  @"Jane",  @"Jesse",  @"Keri",  @"Julia",  @"Tami",  @"Alice",  @"Susan",  @"Shannon",  @"Patricia",  @"Amanda",  @"Cynthia",  @"Karen",  @"Lori",  @"Rachel",  @"Dana",  @"Theresa",  @"Jamie",  @"Deborah",  @"Sherry",  @"Dawn",  @"Andrea",  @"Crystal",  @"Tina",  @"Wendy",  @"Monica",  @"Sandra",  @"Erica",  @"April",  @"Brandi",  @"Caroline",  @"Tiffany",  @"Erin",  @"Joan",  @"Tara",  @"Jacqueli",  @"Danielle",  @"Margaret",  @"Robin",  @"Lee",  @"Jill",  @"Pamela",  @"Holly",  @"Jodi",  @"Tonya",  @"Victoria",  @"Brenda",  @"Denise",  @"Emily",  @"Melanie",  @"Tania",  @"Lesley",  @"Dinah",  @"Linda",  @"Rose",  @"Amber",  @"Megan",  @"Sharon",  @"Cheryl",  @"Ellen",  @"Donna",  @"Sonia",  @"Georgina",  @"Rene",  @"Barbara",  @"Rhonda",  @"Nancy",  @"Heidi",  @"Misty",  @"Shelly",  @"Karla",  @"Veronica",  @"Paula",  @"Valerie",  @"Tamar",  @"Melinda",  @"Shawna",  @"Teri",  @"Sheila",  @"Joyce",  @"Vanessa",  @"Regina",  @"Candice",  @"Lyn",  @"Natalia",  @"Marci",  @"Samantha",  @"Diane",  @"Carmen",  @"Yolanda",  @"Martha",  @"Bridget",  @"Toni",  @"Roberta",  @"Casandra",  @"Katrina",  @"Courtney",  @"Colleen",  @"Dara",  @"Sabina",  @"Evelyn",  @"Constanc",  @"Felicia",  @"Latoya",  @"Lauren",  @"Adriana",  @"Ashley",  @"Frances",  @"Lindsey",  @"Kara",  @"Judy",  @"Audrey",  @"Bonnie",  @"Wanda",  @"Natasha",  @"Virginia",  @"Janice",  @"Nora",  @"Tabitha",  @"Betty",  @"Sylvia",  @"Yvonne",  @"Latasha",  @"Meredith",  @"Mandy",  @"Yvette",  @"Kendra",  @"Claud",  @"Ruth",  @"Lou",  @"Leta",  @"Gwen",  @"Penelope",  @"Gloria",  @"Helen",  @"Janine",  @"Mindy",  @"Brooke",  @"Charlott",  @"Marla",  @"Charlene",  @"Bethany",  @"Maureen",  @"Melody",  @"Belinda",  @"Dorothy",  @"Gretchen",  @"Wilma",  @"Beverly",  @"Trina",  @"Alexandr",  @"Tasha",  @"Clara",  @"Juana",  @"Casey",  @"Lucy",  @"Naomi",  @"Ginger",  @"Abigail",  @"Shirley",  @"Hope",  @"Lakeisha",  @"Rita",  @"Cecilia",  @"Raquel",  @"Marilyn",  @"Gail",  @"Desiree",  @"Sally",  @"Rochelle",  @"Lily",  @"Josephin",  @"Charity",  @"Lydia",  @"Rox",  @"Priscill",  @"Marisol",  @"Keisha",  @"Grace",  @"Maribel",  @"Kirsten",  @"Summer",  @"Hillary",  @"Irene",  @"Marisa",  @"Selina",  @"Camilla",  @"Katina",  @"Esther",  @"Olive",  @"Iris",  @"Glenda",  @"Jasmin",  @"Nina",  @"Gabriell",  @"Alisa",  @"Ebony",  @"Autumn",  @"Chandra",  @"Cora",  @"Jolene",  @"Deana",  @"Sophia",  @"Ruby",  @"Geri",  @"Beatrice",  @"Melisa",  @"Kenya",  @"Shelby",  @"Dahlia",  @"Tanisha",  @"Vivian",  @"Alma",  @"May",  @"Madeline",  @"Yesenia",  @"Geneva",  @"Faith",  @"Alexis",  @"Brianna",  @"Guadalup",  @"Jocelyn",  @"Ramona",  @"Celeste",  @"Arlene",  @"Ada",  @"Amelia",  @"Chasity",  @"Doris",  @"Lana",  @"Berna",  @"Serena",  @"Olga",  @"Tisha",  @"Tia",  @"Terra",  @"Maritza",  @"Dora",  @"Blanche",  @"Daphne",  @"Whitney",  @"Shonda",  @"Malinda",  @"Isabella",  @"Irma",  @"Latanya",  @"Chastity",  @"Laurel",  @"Corinne",  @"Hannah",  @"Lawanda",  @"Ladonna",  @"Paige",  @"Ingrid",  @"Kisha",  @"Mia",  @"Aisha",  @"Misti",  @"Lacy",  @"Edith",  @"Damaris",  @"Edna",  @"Catrina",  @"Karrie",  @"Catina",  @"Daisy",  @"Kay",  @"Dolores",  @"Dion",  @"Lourdes",  @"Mandi",  @"Phyllis",  @"Lashonda",  @"Esmerald",  @"Gena",  @"Shanda",  @"Alana",  @"Britney",  @"Lakesha",  @"Nadine",  @"Mildred",  @"Marta",  @"Chelsea",  @"Doreen",  @"Chanda",  @"Tera",  @"Noelle",  @"Caryn",  @"Janel",  @"Myra",  @"Latrice",  @"Tori",  @"Nakia",  @"Carissa",  @"Randi",  @"Deirdra",  @"Deirdre",  @"Haley",  @"Mona",  @"Cristy",  @"Araceli",  @"Hilda",  @"Demetria",  @"Ursula",  @"Lashawn",  @"Antonia",  @"Bertha",  @"Farrah",  @"June",  @"Christal",  @"Ami",  @"Anitra",  @"Maricela",  @"Kylie",  @"Larissa",  @"Lois",  @"Anissa",  @"Charmain",  @"Milagros",  @"Shellie",  @"Nadia",  @"Latosha",  @"Malissa",  @"Marlo",  @"Tawana",  @"Athena",  @"Tessa",  @"Kristal",  @"Bernice",  @"Elissa",  @"Ivelisse",  @"Ivy",  @"Bianca",  @"Kesha",  @"Cori",  @"Stella",  @"Latonia",  @"Anastasi",  @"Justina",  @"Trudy",  @"Adrianne",  @"Colette",  @"Delores",  @"Corey",  @"Consuelo",  @"Yadira",  @"Taryn",  @"Tonja",  @"Danette",  @"Aida",  @"Marlena",  @"Florence",  @"Jeanna",  @"Deann",  @"Eugenie",  @"Myrna",  @"Chantel",  @"Sasha",  @"Leona",  @"Michell",  @"Tosha",  @"Buffy",  @"Devin",  @"Stacia",  @"Tiffanie",  @"Tamera",  @"Kami",  @"Marnie",  @"Tyra",  @"Corrie",  @"Marina",  @"Danelle",  @"Geraldin",  @"Sandi",  @"Chris",  @"Holli",  @"Windy",  @"Marisela",  @"Tawanda",  @"Shannan",  @"Dominiqu",  @"Shanta",  @"Shanon",  @"Candi",  @"Richelle",  @"Thelma",  @"Alecia",  @"Tawnya",  @"Greta",  @"Mercedes",  @"Karie",  @"Jason",  @"Tomeka",  @"Christia",  @"Sharonda",  @"Sunshine",  @"Mitzi",  @"Shelli",  @"Migdalia",  @"Nanette",  @"Joey",  @"Andria",  @"Felecia",  @"Martina",  @"Ryan",  @"Niki",  @"Kori",  @"Venus",  @"Brian",  @"Jaimie",  @"Toya",  @"Tamiko",  @"Tanika",  @"Carie",  @"Mellissa",  @"Mindi",  @"Joelle",  @"Deidra",  @"Mechelle",  @"Kia",  @"Benita",  @"Simone",  @"Charla",  @"Shalonda",  @"Sharla",  @"Dixie",  @"Rae",  @"Davina",  @"Destiny",  @"Latricia",  @"Rocio",  @"Leila",  @"Stepheni",  @"Anjanett",  @"Celina",  @"India",  @"Lashanda",  @"Monika",  @"Eunice",  @"Cory",  @"Tarsha",  @"Darcie",  @"Aurora",  @"Tressa",  @"Noel",  @"Omayra",  @"Brenna",  @"Shani",  @"Chiquita",  @"Griselda",  @"Kizzy",  @"Nichol",  @"Lissette",  @"Tomika",  @"Hazel",  @"Chrissy",  @"Sherita",  @"Valencia",  @"Charisse",  @"Tawanna",  @"Jade",  @"Sunny",  @"Raina",  @"Tana",  @"Kandi",  @"Shantel",  @"Laquita",  @"Juli",  @"Lakeshia",  @"Brook",  @"Tamela",  @"Lola",  @"Shonna",  @"Frederic",  @"Fay",  @"Waleska",  @"Nikita",  @"Corinna",  @"Sharlene",  @"Yahaira",  @"Trista",  @"Darci",  @"Mellisa",  @"Candida",  @"Danita",  @"Ayanna",  @"Ethel",  @"Brandee",  @"Adriane",  @"Yolonda",  @"Venessa",  @"Jamila",  @"Morgan",  @"Ivonne",  @"Kira",  @"Shara",  @"Karri",  @"Spring",  @"Julissa",  @"Missy",  @"Rosario",  @"Evette",  @"Denice",  @"Brigette",  @"Caren",  @"Jena",  @"Nicolle",  @"Cary",  @"Xiomara",  @"Jacqulin",  @"Alysia",  @"Trena",  @"Caitlin",  @"Ginny",  @"Carisa",  @"Carri",  @"Melonie",  @"Ileana",  @"Danna",  @"Jackelin",  @"Cindi",  @"Bree",  @"Eric",  @"Jeana",  @"Viviana",  @"Renita",  @"Christel",  @"Fatima",  @"Octavia",  @"Tennille",  @"Yanira",  @"Shawanda",  @"Harmony",  @"Johnna",  @"Johnnie",  @"Shanika",  @"Lindy",  @"Tangela",  @"Regan",  @"Melodie",  @"Charissa",  @"Jammie",  @"Elvira",  @"Avice",  @"Alina",  @"Chanelle",  @"Jewel",  @"Bambi",  @"Rolanda",  @"Keesha",  @"Liz",  @"Rhian",  @"Dori",  @"Crissy",  @"Tiana",  @"Aretha",  @"Josette",  @"Cherise",  @"Pearl",  @"Petrina",  @"Nicki",  @"Leilani",  @"Kenyatta"];
}

- (NSArray *)mensFirstNames
{
    return @[@"John",  @"Michael",  @"Joseph",  @"Christop",  @"Matthew",  @"Josuah",  @"Nicholas",  @"Jacob",  @"James",  @"Daniel",  @"Andrew",  @"Alexande",  @"Tyler",  @"David",  @"Brandon",  @"Robert",  @"Ryan",  @"William",  @"Zachary",  @"Justin",  @"Anthony",  @"Stephen",  @"Brian",  @"Austin",  @"Kyle",  @"Kevin",  @"Thomas",  @"Nathan",  @"Cody",  @"Shawn",  @"Richard",  @"Jordan",  @"Eric",  @"Benjamin",  @"Aaron",  @"Mark",  @"Samuel",  @"Dylan",  @"Timothy",  @"Adam",  @"Jeremiah",  @"Lewis",  @"Charles",  @"Jeffrey",  @"Patrick",  @"Jason",  @"Jesse",  @"Derek",  @"Juan",  @"Cameron",  @"Travis",  @"Kenneth",  @"Caleb",  @"Carlos",  @"Jared",  @"Ethan",  @"Taylor",  @"Logan",  @"Paul",  @"Trevor",  @"Dustin",  @"Edward",  @"Evan",  @"Gabriel",  @"Ian",  @"Gregory",  @"Jack",  @"Connor",  @"Anton",  @"Devin",  @"Corey",  @"Scott",  @"Jesus",  @"Hunter",  @"Colin",  @"Philip",  @"Bradley",  @"Garrett",  @"Mitchell",  @"Allan",  @"Dakota",  @"Shane",  @"Victor",  @"Blake",  @"Peter",  @"Miguel",  @"Noah",  @"Luke",  @"Adrian",  @"Raymond",  @"Seth",  @"Isaac",  @"Max",  @"Spencer",  @"Chase",  @"Vincent",  @"Jorge",  @"Lucas",  @"Isaiah",  @"Francis",  @"Cory",  @"Tanner",  @"George",  @"Brett",  @"Joel",  @"Erik",  @"Brendan",  @"Ronald",  @"Dalton",  @"Alejandr",  @"Terence",  @"Frank",  @"Dominic",  @"Cole",  @"Dillon",  @"Donald",  @"Jake",  @"Damien",  @"Elijah",  @"Mason",  @"Wesley",  @"Casey",  @"Eduardo",  @"Colton",  @"Laurence",  @"Keith",  @"Chad",  @"Julian",  @"Devon",  @"Oscar",  @"Mario",  @"Manuel",  @"Bryce",  @"Grant",  @"Xavier",  @"Martin",  @"Henry",  @"Javier",  @"Carl",  @"Edgar",  @"Omar",  @"Hector",  @"Douglas",  @"Frederic",  @"Tristan",  @"Troy",  @"Emanuel",  @"Sergio",  @"Ferdinan",  @"Andre",  @"Edwin",  @"Ivan",  @"Cristian",  @"Clayton",  @"Levi",  @"Curtis",  @"Gary",  @"Darius",  @"Reuben",  @"Dennis",  @"Andres",  @"Daren",  @"Cesar",  @"Drew",  @"Randy",  @"Pedro",  @"Alexis",  @"Daryl",  @"Brent",  @"Marco",  @"Julio",  @"Riley",  @"Wyatt",  @"Malik",  @"Leonard",  @"Jerry",  @"Craig",  @"Calvin",  @"Tony",  @"Rafael",  @"Preston",  @"Miles",  @"Erick",  @"Brady",  @"Raul",  @"Zachery",  @"Loren",  @"Hayden",  @"Gavin",  @"Kristoph",  @"Trenton",  @"Albert",  @"Colby",  @"Russell",  @"Sebastia",  @"Harrison",  @"Parker",  @"Alberto",  @"Chance",  @"Kaleb",  @"Rodney",  @"Gerardo",  @"Theodore",  @"Micah",  @"Lance",  @"Marcos",  @"Trey",  @"Conner",  @"Abraham",  @"Giovanni",  @"Armando",  @"Dominiqu",  @"Diego",  @"Walter",  @"Arthur",  @"Harry",  @"Skyler",  @"Gage",  @"Todd",  @"Enrique",  @"Donovan",  @"Chandler",  @"Ramon",  @"Zackary",  @"Roger",  @"Ross",  @"Landon",  @"Harley",  @"Jay",  @"Trent",  @"Gilbert",  @"Jamal",  @"Israel",  @"Randall",  @"Branden",  @"Neil",  @"Alfredo",  @"Elliott",  @"Sidney",  @"Deandre",  @"Gerald",  @"Jalen",  @"Morgan",  @"Reginald",  @"Nolan",  @"Lee",  @"Zacharia",  @"Liam",  @"Dante",  @"Marvin",  @"Arturo",  @"Maurice",  @"Josiah",  @"Kelvin",  @"Malcolm",  @"Kody",  @"Gustavo",  @"Marquis",  @"Dallas",  @"Glen",  @"Nelson",  @"Roy",  @"Salvador",  @"Ty",  @"Tevin",  @"Brock",  @"Avery",  @"Conor",  @"Orlando",  @"Owen",  @"Ashton",  @"Fabian",  @"Brennan",  @"Bruce",  @"Dean",  @"Rene",  @"Duane",  @"Clinton",  @"Marshall",  @"Demetriu",  @"Pablo",  @"Carter",  @"Zane",  @"Bailey",  @"Steve",  @"Wayne",  @"Ismael",  @"Ernesto",  @"Quentin",  @"Terrell",  @"Quinton",  @"Carson",  @"Felix",  @"Desmond",  @"Elias",  @"Byron",  @"Kendall",  @"Eli",  @"Hugh",  @"Tyrone",  @"Angelo",  @"Jerome",  @"Melvin",  @"Simon",  @"Jakob",  @"Brenden",  @"Forrest",  @"Braden",  @"Saul",  @"Esteban",  @"Zackery",  @"Drake",  @"Griffin",  @"Jarret",  @"Roman",  @"Guillerm",  @"Emilio",  @"Aidan",  @"Alvin",  @"Leonardo",  @"Devante",  @"Tucker",  @"Oliver",  @"Keegan",  @"Jean",  @"Ernest",  @"Dale",  @"Kameron",  @"Cedric",  @"Irvine",  @"Abel",  @"Keenan",  @"Quinn",  @"Eugene",  @"Stewart",  @"Moises",  @"Stanley",  @"Wade",  @"Jordon",  @"Alonzo",  @"Weston",  @"Lane",  @"Denzel",  @"Felipe",  @"Devonte",  @"Cooper",  @"Jarrod",  @"Jermaine",  @"Rodolfo",  @"Kendrick",  @"Tyrell",  @"Graham",  @"Beau",  @"Kyler",  @"Warren",  @"Donte",  @"Joey",  @"Kurt",  @"Clay",  @"Noel",  @"Devan",  @"Skylar",  @"Dane",  @"Corbin",  @"Kristian",  @"Nikolas",  @"Alfred",  @"Jarred",  @"Peyton",  @"Rudy",  @"Bryson",  @"Alfonso",  @"Darian",  @"Shaquill",  @"Brad",  @"Trevon",  @"Ralph",  @"Lukas",  @"Reid",  @"Toby",  @"Davis",  @"Deshawn",  @"Wilson",  @"Darnell",  @"Davon",  @"Sheldon",  @"Rodrigo",  @"Justice",  @"Jayson",  @"Marlon",  @"Ali",  @"Rashad",  @"Sterling",  @"Ariel",  @"Brody",  @"Efrain",  @"Julius",  @"Rolando",  @"Ramiro",  @"Kurtis",  @"Keaton",  @"Tylor",  @"Kelly",  @"Reed",  @"Mackenzi",  @"Javon",  @"Bernard",  @"Braxton",  @"Payton",  @"Marquise",  @"Barry",  @"Earl",  @"Rees",  @"Tyson",  @"Clarence",  @"Clint",  @"Daquan",  @"Blaine",  @"Santiago",  @"Khalil",  @"Nathanae",  @"Perry",  @"Lamar",  @"Nigel",  @"Grayson",  @"Roderick",  @"Tristen",  @"Brayden",  @"Bret",  @"Clifford",  @"Mauricio",  @"Quincy",  @"Rogelio",  @"Dexter",  @"Adan",  @"Kirk",  @"Kory",  @"Dorian",  @"Gordon",  @"Heath",  @"Deon",  @"Brenton",  @"Norman",  @"Tyree",  @"Courtney",  @"Jace",  @"Jaquan",  @"Alvaro",  @"Duncan",  @"Demarcus",  @"Humberto",  @"Osvaldo",  @"Deangelo",  @"Dwight",  @"Jarvis",  @"Vicente",  @"Markus",  @"Reynaldo",  @"Uriel",  @"Noe",  @"Amir",  @"Ezekiel",  @"Chaz",  @"Greg",  @"Deonte",  @"Kasey",  @"Jamar",  @"Shelby",  @"Leroy",  @"Damion",  @"Darien",  @"Mohammad",  @"Quintin",  @"Howard",  @"Stephon",  @"Roland",  @"Ahmad",  @"Corneliu",  @"Jaron",  @"Milton",  @"Everett",  @"Coty",  @"Triston",  @"Shannon",  @"Cade",  @"Antwan",  @"Joaquin",  @"Tracy",  @"Lonnie",  @"Colten",  @"Jarod",  @"Addison",  @"Salvator",  @"Jaden",  @"Tate",  @"Walker",  @"Arnold",  @"Solomon",  @"Leonel",  @"Korey",  @"Brice",  @"Dion",  @"Kareem",  @"Mohammed",  @"Edgardo",  @"Dashawn",  @"Sawyer",  @"Ezequiel",  @"Jan",  @"Adolfo",  @"Tre",  @"Rigobert",  @"Jovan",  @"Vernon",  @"Guadalup",  @"Holden",  @"Raphael",  @"Deion",  @"Dandre",  @"Dillan",  @"Herbert",  @"Tristin",  @"Cullen",  @"Coleman",  @"Marcel",  @"Kristofe",  @"Jaylen",  @"Clifton",  @"Clark",  @"Rick",  @"Raheem",  @"Deven",  @"Jimmie",  @"Lamont",  @"Jamel",  @"Kent",  @"Dawson",  @"Ezra",  @"German",  @"Nestor",  @"Cortez",  @"Darion",  @"Rory",  @"Lloyd",  @"Moses",  @"Malachi",  @"Guy",  @"Ahmed",  @"Rickey",  @"Axel",  @"Kerry",  @"Agustin",  @"Conrad",  @"Brooks",  @"Darrius",  @"Jerrod",  @"Dana",  @"Akeem",  @"Santos",  @"Bernardo",  @"Kai",  @"Winston",  @"Ignacio",  @"Gunnar",  @"Juwan",  @"Kolby",  @"Jefferso",  @"Wilfredo",  @"Pierce",  @"Blair",  @"Gerard",  @"Heribert",  @"Elmer",  @"Houston",  @"Rashawn",  @"Dimitri",  @"Elvis",  @"Jasper",  @"Jairo",  @"Colt",  @"Donnie",  @"Sage",  @"Madison",  @"Kaden",  @"Mohamed",  @"Wendell",  @"Bradford",  @"Jamison",  @"Dequan",  @"Gene",  @"Robin",  @"Jameson",  @"Gonzalo",  @"Rhett",  @"Bennett",  @"Moshe",  @"Kade",  @"Isaias",  @"Davonte",  @"Thaddeus",  @"Camden",  @"Davion",  @"Jamil",  @"Misael",  @"Travon",  @"Leland",  @"Trever",  @"Hassan",  @"Cruz",  @"Donavan",  @"Paris",  @"Nico",  @"Ladarius",  @"Zakary",  @"Leslie",  @"Gino",  @"Pierre",  @"Kolton",  @"Jaleel",  @"Trace",  @"Dewayne",  @"Myron",  @"Cyrus",  @"Dayton",  @"Ulises",  @"Rex",  @"Hakeem",  @"Lester",  @"Rocky",  @"River",  @"Kadeem",  @"Jayden",  @"Erich",  @"Bradly",  @"Jackie",  @"Ryne",  @"Brandyn",  @"Aldo",  @"Camron",  @"Jamarcus",  @"Alton",  @"Keon",  @"Clyde",  @"Rico",  @"Nick",  @"Kane",  @"Estevan",  @"Devonta",  @"Brandan",  @"Dylon",  @"Dangelo",  @"Talon",  @"Cecil",  @"Sonny",  @"Demarco",  @"Dillion",  @"Herman",  @"Brennen",  @"Donnell",  @"Eliezer",  @"Randolph",  @"Benito",  @"Vance",  @"August",  @"Royce",  @"Kellen",  @"Coby",  @"Cordell",  @"Quinten",  @"Floyd",  @"Javonte",  @"Aric",  @"Silas",  @"Ibrahim",  @"Bryon",  @"Kieran",  @"Remingto",  @"Tariq",  @"Devyn",  @"Jaylon",  @"Anderson",  @"Gunner",  @"Octavio",  @"Tory",  @"Shea",  @"Darwin",  @"Jacoby",  @"Codey",  @"Marquez",  @"Layne",  @"Hernan",  @"Bronson",  @"Caden",  @"Keanu",  @"Junior",  @"Lionel",  @"Demario",  @"Raymundo",  @"Eliseo",  @"Grady",  @"Kenton",  @"Otis",  @"Shay",  @"Austyn",  @"Jabari",  @"Ari",  @"Garett",  @"Rusty",  @"Muhammad",  @"Chester",  @"Jorden",  @"Tayler",  @"Niko",  @"Fidel",  @"Dominque",  @"Bo",  @"Adrien",  @"Jerrell",  @"Elvin",  @"Codie",  @"Tyron",  @"Isai",  @"Emmett",  @"Montana",  @"Lincoln",  @"Kelsey",  @"Amos",  @"Keven",  @"Dario",  @"Khalid",  @"Dakotah",  @"Dallin",  @"Darrian",  @"Mateo",  @"Garrison",  @"Jamaal",  @"Justus",  @"Elisha",  @"Deondre",  @"Dontae",  @"Kobe",  @"Lyle",  @"Forest",  @"Justyn",  @"Edmond",  @"Ervin",  @"Chadwick",  @"Aiden",  @"Schuyler",  @"Jerald",  @"Derik",  @"Destin",  @"Broderic",  @"Dusty",  @"Isidro",  @"Adonis",  @"Mikel",  @"Spenser",  @"Barrett",  @"Vaughn",  @"Davin",  @"Daron",  @"Orion",  @"Tavon",  @"Darrion",  @"Stone",  @"Antwon",  @"Raekwon",  @"Dejuan",  @"Maximill",  @"Deshaun",  @"Jude",  @"Tyshawn",  @"Ron",  @"Kelby",  @"Domenic",  @"Ulysses",  @"Jerod",  @"Kelton",  @"Morris",  @"Rey",  @"Jade",  @"Abdiel",  @"Efren",  @"Kevon",  @"Hudson",  @"Ashley",  @"Kendal",  @"Mickey",  @"Najee",  @"Ryder",  @"Brandt",  @"Kirby",  @"Armani",  @"Kalvin",  @"Syed",  @"Tyquan",  @"Jedidiah",  @"Brant",  @"Reggie",  @"Valentin",  @"Jomar",  @"Marques",  @"Armand",  @"Ellis",  @"Kegan",  @"Carlo",  @"Diamond",  @"Justen",  @"Jovanny",  @"Kwame",  @"Romeo",  @"Dionte",  @"Nicklaus",  @"Darrien",  @"Trae",  @"Galen",  @"Devontae",  @"Denver",  @"Kole",  @"Asa",  @"Hans",  @"Jody",  @"Lazaro",  @"Rasheed",  @"Alden",  @"Rayshawn",  @"Luciano",  @"Kalen",  @"Rudolph",  @"Jaylin",  @"Jonatan",  @"Claude",  @"Brayan",  @"Ridge",  @"Cristoba",  @"Koby",  @"Omari",  @"Harvey",  @"Nikhil",  @"Francesc",  @"Storm",  @"Stetson",  @"Jovany",  @"Tristian",  @"Giancarl",  @"Giovanny",  @"Genaro",  @"Braydon",  @"Elton",  @"Prince",  @"Cale",  @"Sampson",  @"Sherman",  @"Rohan",  @"Abdullah",  @"Asher",  @"Timmy"];
}

- (NSArray *)lastNames
{
    return @[@"Smith",  @"Johnson",  @"Williams",  @"Jones",  @"Brown",  @"Davis",  @"Miller",  @"Wilson",  @"Moore",  @"Taylor",  @"Anderson",  @"Thomas",  @"Jackson",  @"White",  @"Harris",  @"Martin",  @"Thompson",  @"Garcia",  @"Martinez",  @"Robinson",  @"Clark",  @"Rodriguez",  @"Lewis",  @"Lee",  @"Walker",  @"Hall",  @"Allen",  @"Young",  @"Hernandez",  @"King",  @"Wright",  @"Lopez",  @"Hill",  @"Scott",  @"Green",  @"Adams",  @"Baker",  @"Gonzalez",  @"Nelson",  @"Carter",  @"Mitchell",  @"Perez",  @"Roberts",  @"Turner",  @"Phillips",  @"Campbell",  @"Parker",  @"Evans",  @"Edwards",  @"Collins",  @"Stewart",  @"Sanchez",  @"Morris",  @"Rogers",  @"Reed",  @"Cook",  @"Morgan",  @"Bell",  @"Murphy",  @"Bailey",  @"Rivera",  @"Cooper",  @"Richardson",  @"Cox",  @"Howard",  @"Ward",  @"Torres",  @"Peterson",  @"Gray",  @"Ramirez",  @"James",  @"Watson",  @"Brooks",  @"Kelly",  @"Sanders",  @"Price",  @"Bennett",  @"Wood",  @"Barnes",  @"Ross",  @"Henderson",  @"Coleman",  @"Jenkins",  @"Perry",  @"Powell",  @"Long",  @"Patterson",  @"Hughes",  @"Flores",  @"Washington",  @"Butler",  @"Simmons",  @"Foster",  @"Gonzales",  @"Bryant",  @"Alexander",  @"Russell",  @"Griffin",  @"Diaz",  @"Hayes",  @"Myers",  @"Ford",  @"Hamilton",  @"Graham",  @"Sullivan",  @"Wallace",  @"Woods",  @"Cole",  @"West",  @"Jordan",  @"Owens",  @"Reynolds",  @"Fisher",  @"Ellis",  @"Harrison",  @"Gibson",  @"Mcdonald",  @"Cruz",  @"Marshall",  @"Ortiz",  @"Gomez",  @"Murray",  @"Freeman",  @"Wells",  @"Webb",  @"Simpson",  @"Stevens",  @"Tucker",  @"Porter",  @"Hunter",  @"Hicks",  @"Crawford",  @"Henry",  @"Boyd",  @"Mason",  @"Morales",  @"Kennedy",  @"Warren",  @"Dixon",  @"Ramos",  @"Reyes",  @"Burns",  @"Gordon",  @"Shaw",  @"Holmes",  @"Rice",  @"Robertson",  @"Hunt",  @"Black",  @"Daniels",  @"Palmer",  @"Mills",  @"Nichols",  @"Grant",  @"Knight",  @"Ferguson",  @"Rose",  @"Stone",  @"Hawkins",  @"Dunn",  @"Perkins",  @"Hudson",  @"Spencer",  @"Gardner",  @"Stephens",  @"Payne",  @"Pierce",  @"Berry",  @"Matthews",  @"Arnold",  @"Wagner",  @"Willis",  @"Ray",  @"Watkins",  @"Olson",  @"Carroll",  @"Duncan",  @"Snyder",  @"Hart",  @"Cunningham",  @"Bradley",  @"Lane",  @"Andrews",  @"Ruiz",  @"Harper",  @"Fox",  @"Riley",  @"Armstrong",  @"Carpenter",  @"Weaver",  @"Greene",  @"Lawrence",  @"Elliott",  @"Chavez",  @"Sims",  @"Austin",  @"Peters",  @"Kelley",  @"Franklin",  @"Lawson",  @"Fields",  @"Gutierrez",  @"Ryan",  @"Schmidt",  @"Carr",  @"Vasquez",  @"Castillo",  @"Wheeler",  @"Chapman",  @"Oliver",  @"Montgomery",  @"Richards",  @"Williamson",  @"Johnston",  @"Banks",  @"Meyer",  @"Bishop",  @"Mccoy",  @"Howell",  @"Alvarez",  @"Morrison",  @"Hansen",  @"Fernandez",  @"Garza",  @"Harvey",  @"Little",  @"Burton",  @"Stanley",  @"Nguyen",  @"George",  @"Jacobs",  @"Reid",  @"Kim",  @"Fuller",  @"Lynch",  @"Dean",  @"Gilbert",  @"Garrett",  @"Romero",  @"Welch",  @"Larson",  @"Frazier",  @"Burke",  @"Hanson",  @"Day",  @"Mendoza",  @"Moreno",  @"Bowman",  @"Medina",  @"Fowler",  @"Brewer",  @"Hoffman",  @"Carlson",  @"Silva",  @"Pearson",  @"Holland",  @"Douglas",  @"Fleming",  @"Jensen",  @"Vargas",  @"Byrd",  @"Davidson",  @"Hopkins",  @"May",  @"Terry",  @"Herrera",  @"Wade",  @"Soto",  @"Walters",  @"Curtis",  @"Neal",  @"Caldwell",  @"Lowe",  @"Jennings",  @"Barnett",  @"Graves",  @"Jimenez",  @"Horton",  @"Shelton",  @"Barrett",  @"Obrien",  @"Castro",  @"Sutton",  @"Gregory",  @"Mckinney",  @"Lucas",  @"Miles",  @"Craig",  @"Rodriquez",  @"Chambers",  @"Holt",  @"Lambert",  @"Fletcher",  @"Watts",  @"Bates",  @"Hale",  @"Rhodes",  @"Pena",  @"Beck",  @"Newman",  @"Haynes",  @"Mcdaniel",  @"Mendez",  @"Bush",  @"Vaughn",  @"Parks",  @"Dawson",  @"Santiago",  @"Norris",  @"Hardy",  @"Love",  @"Steele",  @"Curry",  @"Powers",  @"Schultz",  @"Barker",  @"Guzman",  @"Page",  @"Munoz",  @"Ball",  @"Keller",  @"Chandler",  @"Weber",  @"Leonard",  @"Walsh",  @"Lyons",  @"Ramsey",  @"Wolfe",  @"Schneider",  @"Mullins",  @"Benson",  @"Sharp",  @"Bowen",  @"Daniel",  @"Barber",  @"Cummings",  @"Hines",  @"Baldwin",  @"Griffith",  @"Valdez",  @"Hubbard",  @"Salazar",  @"Reeves",  @"Warner",  @"Stevenson",  @"Burgess",  @"Santos",  @"Tate",  @"Cross",  @"Garner",  @"Mann",  @"Mack",  @"Moss",  @"Thornton",  @"Dennis",  @"Mcgee",  @"Farmer",  @"Delgado",  @"Aguilar",  @"Vega",  @"Glover",  @"Manning",  @"Cohen",  @"Harmon",  @"Rodgers",  @"Robbins",  @"Newton",  @"Todd",  @"Blair",  @"Higgins",  @"Ingram",  @"Reese",  @"Cannon",  @"Strickland",  @"Townsend",  @"Potter",  @"Goodwin",  @"Walton",  @"Rowe",  @"Hampton",  @"Ortega",  @"Patton",  @"Swanson",  @"Joseph",  @"Francis",  @"Goodman",  @"Maldonado",  @"Yates",  @"Becker",  @"Erickson",  @"Hodges",  @"Rios",  @"Conner",  @"Adkins",  @"Webster",  @"Norman",  @"Malone",  @"Hammond",  @"Flowers",  @"Cobb",  @"Moody",  @"Quinn",  @"Blake",  @"Maxwell",  @"Pope",  @"Floyd",  @"Osborne",  @"Paul",  @"Mccarthy",  @"Guerrero",  @"Lindsey",  @"Estrada",  @"Sandoval",  @"Gibbs",  @"Tyler",  @"Gross",  @"Fitzgerald",  @"Stokes",  @"Doyle",  @"Sherman",  @"Saunders",  @"Wise",  @"Colon",  @"Gill",  @"Alvarado",  @"Greer",  @"Padilla",  @"Simon",  @"Waters",  @"Nunez",  @"Ballard",  @"Schwartz",  @"Mcbride",  @"Houston",  @"Christensen",  @"Klein",  @"Pratt",  @"Briggs",  @"Parsons",  @"Mclaughlin",  @"Zimmerman",  @"French",  @"Buchanan",  @"Moran",  @"Copeland",  @"Roy",  @"Pittman",  @"Brady",  @"Mccormick",  @"Holloway",  @"Brock",  @"Poole",  @"Frank",  @"Logan",  @"Owen",  @"Bass",  @"Marsh",  @"Drake",  @"Wong",  @"Jefferson",  @"Park",  @"Morton",  @"Abbott",  @"Sparks",  @"Patrick",  @"Norton",  @"Huff",  @"Clayton",  @"Massey",  @"Lloyd",  @"Figueroa",  @"Carson",  @"Bowers",  @"Roberson",  @"Barton",  @"Tran",  @"Lamb",  @"Harrington",  @"Casey",  @"Boone",  @"Cortez",  @"Clarke",  @"Mathis",  @"Singleton",  @"Wilkins",  @"Cain",  @"Bryan",  @"Underwood",  @"Hogan",  @"Mckenzie",  @"Collier",  @"Luna",  @"Phelps",  @"Mcguire",  @"Allison",  @"Bridges",  @"Wilkerson",  @"Nash",  @"Summers",  @"Atkins",  @"Wilcox",  @"Pitts",  @"Conley",  @"Marquez",  @"Burnett",  @"Richard",  @"Cochran",  @"Chase",  @"Davenport",  @"Hood",  @"Gates",  @"Clay",  @"Ayala",  @"Sawyer",  @"Roman",  @"Vazquez",  @"Dickerson",  @"Hodge",  @"Acosta",  @"Flynn",  @"Espinoza",  @"Nicholson",  @"Monroe",  @"Wolf",  @"Morrow",  @"Kirk",  @"Randall",  @"Anthony",  @"Whitaker",  @"Oconnor",  @"Skinner",  @"Ware",  @"Molina",  @"Kirby",  @"Huffman",  @"Bradford",  @"Charles",  @"Gilmore",  @"Dominguez",  @"Oneal",  @"Bruce",  @"Lang",  @"Combs",  @"Kramer",  @"Heath",  @"Hancock",  @"Gallagher",  @"Gaines",  @"Shaffer",  @"Short",  @"Wiggins",  @"Mathews",  @"Mcclain",  @"Fischer",  @"Wall",  @"Small",  @"Melton",  @"Hensley",  @"Bond",  @"Dyer",  @"Cameron",  @"Grimes",  @"Contreras",  @"Christian",  @"Wyatt",  @"Baxter",  @"Snow",  @"Mosley",  @"Shepherd",  @"Larsen",  @"Hoover",  @"Beasley",  @"Glenn",  @"Petersen",  @"Whitehead",  @"Meyers",  @"Keith",  @"Garrison",  @"Vincent",  @"Shields",  @"Horn",  @"Savage",  @"Olsen",  @"Schroeder",  @"Hartman",  @"Woodard",  @"Mueller",  @"Kemp",  @"Deleon",  @"Booth",  @"Patel",  @"Calhoun",  @"Wiley",  @"Eaton",  @"Cline",  @"Navarro",  @"Harrell",  @"Lester",  @"Humphrey",  @"Parrish",  @"Duran",  @"Hutchinson",  @"Hess",  @"Dorsey",  @"Bullock",  @"Robles",  @"Beard",  @"Dalton",  @"Avila",  @"Vance",  @"Rich",  @"Blackwell",  @"York",  @"Johns",  @"Blankenship",  @"Trevino",  @"Salinas",  @"Campos",  @"Pruitt",  @"Moses",  @"Callahan",  @"Golden",  @"Montoya",  @"Hardin",  @"Guerra",  @"Mcdowell",  @"Carey",  @"Stafford",  @"Gallegos",  @"Henson",  @"Wilkinson",  @"Booker",  @"Merritt",  @"Miranda",  @"Atkinson",  @"Orr",  @"Decker",  @"Hobbs",  @"Preston",  @"Tanner",  @"Knox",  @"Pacheco",  @"Stephenson",  @"Glass",  @"Rojas",  @"Serrano",  @"Marks",  @"Hickman",  @"English",  @"Sweeney",  @"Strong",  @"Prince",  @"Mcclure",  @"Conway",  @"Walter",  @"Roth",  @"Maynard",  @"Farrell",  @"Lowery",  @"Hurst",  @"Nixon",  @"Weiss",  @"Trujillo",  @"Ellison",  @"Sloan",  @"Juarez",  @"Winters",  @"Mclean",  @"Randolph",  @"Leon",  @"Boyer",  @"Villarreal",  @"Mccall",  @"Gentry",  @"Carrillo",  @"Kent",  @"Ayers",  @"Lara",  @"Shannon",  @"Sexton",  @"Pace",  @"Hull",  @"Leblanc",  @"Browning",  @"Velasquez",  @"Leach",  @"Chang",  @"House",  @"Sellers",  @"Herring",  @"Noble",  @"Foley",  @"Bartlett",  @"Mercado",  @"Landry",  @"Durham",  @"Walls",  @"Barr",  @"Mckee",  @"Bauer",  @"Rivers",  @"Everett",  @"Bradshaw",  @"Pugh",  @"Velez",  @"Rush",  @"Estes",  @"Dodson",  @"Morse",  @"Sheppard",  @"Weeks",  @"Camacho",  @"Bean",  @"Barron",  @"Livingston",  @"Middleton",  @"Spears",  @"Branch",  @"Blevins",  @"Chen",  @"Kerr",  @"Mcconnell",  @"Hatfield",  @"Harding",  @"Ashley",  @"Solis",  @"Herman",  @"Frost",  @"Giles",  @"Blackburn",  @"William",  @"Pennington",  @"Woodward",  @"Finley",  @"Mcintosh",  @"Koch",  @"Best",  @"Solomon",  @"Mccullough",  @"Dudley",  @"Nolan",  @"Blanchard",  @"Rivas",  @"Brennan",  @"Mejia",  @"Kane",  @"Benton",  @"Joyce",  @"Buckley",  @"Haley",  @"Valentine",  @"Maddox",  @"Russo",  @"Mcknight",  @"Buck",  @"Moon",  @"Mcmillan",  @"Crosby",  @"Berg",  @"Dotson",  @"Mays",  @"Roach",  @"Church",  @"Chan",  @"Richmond",  @"Meadows",  @"Faulkner",  @"Oneill",  @"Knapp",  @"Kline",  @"Barry",  @"Ochoa",  @"Jacobson",  @"Gay",  @"Avery",  @"Hendricks",  @"Horne",  @"Shepard",  @"Hebert",  @"Cherry",  @"Cardenas",  @"Mcintyre",  @"Whitney",  @"Waller",  @"Holman",  @"Donaldson",  @"Cantu",  @"Terrell",  @"Morin",  @"Gillespie",  @"Fuentes",  @"Tillman",  @"Sanford",  @"Bentley",  @"Peck",  @"Key",  @"Salas",  @"Rollins",  @"Gamble",  @"Dickson",  @"Battle",  @"Santana",  @"Cabrera",  @"Cervantes",  @"Howe",  @"Hinton",  @"Hurley",  @"Spence",  @"Zamora",  @"Yang",  @"Mcneil",  @"Suarez",  @"Case",  @"Petty",  @"Gould",  @"Mcfarland",  @"Sampson",  @"Carver",  @"Bray",  @"Rosario",  @"Macdonald",  @"Stout",  @"Hester",  @"Melendez",  @"Dillon",  @"Farley",  @"Hopper",  @"Galloway",  @"Potts",  @"Bernard",  @"Joyner",  @"Stein",  @"Aguirre",  @"Osborn",  @"Mercer",  @"Bender",  @"Franco",  @"Rowland",  @"Sykes",  @"Benjamin",  @"Travis",  @"Pickett",  @"Crane",  @"Sears",  @"Mayo",  @"Dunlap",  @"Hayden",  @"Wilder",  @"Mckay",  @"Coffey",  @"Mccarty",  @"Ewing",  @"Cooley",  @"Vaughan",  @"Bonner",  @"Cotton",  @"Holder",  @"Stark",  @"Ferrell",  @"Cantrell",  @"Fulton",  @"Lynn",  @"Lott",  @"Calderon",  @"Rosa",  @"Pollard",  @"Hooper",  @"Burch",  @"Mullen",  @"Fry",  @"Riddle",  @"Levy",  @"David",  @"Duke",  @"Odonnell",  @"Guy",  @"Michael",  @"Britt",  @"Frederick",  @"Daugherty",  @"Berger",  @"Dillard",  @"Alston",  @"Jarvis",  @"Frye",  @"Riggs",  @"Chaney",  @"Odom",  @"Duffy",  @"Fitzpatrick",  @"Valenzuela",  @"Merrill",  @"Mayer",  @"Alford",  @"Mcpherson",  @"Acevedo",  @"Donovan",  @"Barrera",  @"Albert",  @"Cote",  @"Reilly",  @"Compton",  @"Raymond",  @"Mooney",  @"Mcgowan",  @"Craft",  @"Cleveland",  @"Clemons",  @"Wynn",  @"Nielsen",  @"Baird",  @"Stanton",  @"Snider",  @"Rosales",  @"Bright",  @"Witt",  @"Stuart",  @"Hays",  @"Holden",  @"Rutledge",  @"Kinney",  @"Clements",  @"Castaneda",  @"Slater",  @"Hahn",  @"Emerson",  @"Conrad",  @"Burks",  @"Delaney",  @"Pate",  @"Lancaster",  @"Sweet",  @"Justice",  @"Tyson",  @"Sharpe",  @"Whitfield",  @"Talley",  @"Macias",  @"Irwin",  @"Burris",  @"Ratliff",  @"Mccray",  @"Madden",  @"Kaufman",  @"Beach",  @"Goff",  @"Cash",  @"Bolton",  @"Mcfadden",  @"Levine",  @"Good",  @"Byers",  @"Kirkland",  @"Kidd",  @"Workman",  @"Carney",  @"Dale",  @"Mcleod",  @"Holcomb",  @"England",  @"Finch",  @"Head",  @"Burt",  @"Hendrix",  @"Sosa",  @"Haney",  @"Franks",  @"Sargent",  @"Nieves",  @"Downs",  @"Rasmussen",  @"Bird",  @"Hewitt",  @"Lindsay",  @"Le",  @"Foreman",  @"Valencia",  @"Oneil",  @"Delacruz",  @"Vinson",  @"Dejesus",  @"Hyde",  @"Forbes",  @"Gilliam",  @"Guthrie",  @"Wooten",  @"Huber",  @"Barlow",  @"Boyle",  @"Mcmahon",  @"Buckner",  @"Rocha",  @"Puckett",  @"Langley",  @"Knowles",  @"Cooke",  @"Velazquez",  @"Whitley",  @"Noel",  @"Vang"];
}

- (NSArray *)workDomains
{
    return @[@"microsoft.com", @"apple.com", @"yammer-inc.com", @"google.com", @"cnn.com", @"nasa.gov", @"whitehouse.gov", @"mit.edu", @"harvard.edu", @"shell.ca", @"toyota.jp", @"total.com", @"vitol.com", @"glencore.com", @"enron.com", @"chevron.com", @"wal-mart.com"];
}

- (NSArray *)personalDomains
{
    return @[@"yahoo.com", @"gmail.com", @"hotmail.com", @"outlook.com", @"gmail.com", @"yahoo.ca", @"facebook.com"];
}


@end
