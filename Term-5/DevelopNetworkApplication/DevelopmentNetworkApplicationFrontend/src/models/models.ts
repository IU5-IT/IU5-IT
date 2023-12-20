export interface ICities {
    cities: ICity[],
    status: string
}

export interface ICityResponse {
    city: ICity,
    status: string
}

export interface IStatus {
    id: number,
    status_name: string,
}

export interface ICityWithBasket {
    basket_id: number
    cities: ICity[]
}

export interface ICity {
    id: number,
    city_name?: string,
    status_id?: number,
    status: IStatus,
    description?: string,
    image_url?: string,
}

export interface IDestinationHikes {
    id: number,
    city_id: number,
    hike_id: number,
    serial_number: number,
    city: ICity,
}

export interface IRegisterResponse {
    login: string
    password: string
}

export interface IAuthResponse {
    access_token?: string,
    description?: string,
    status?: string,
    role?: string
    userName: string,
    userImage: string
}

export interface UserInfo {
    name: string,
    image: string,
};

export interface IUser {
    id: number,
    user_name: string,
    profession: string,
    login: string,
    birthday: string,
    image_url: string,
    password: string,
}

export interface IHike {
    id: number,
    hike_name: string,
    date_created: string,
    date_end: string,
    date_start_of_processing: string,
    date_approve: string,
    date_start_hike: string,
    user_id: number,
    status_id: number,
    description: string,
    status: IStatus,
    leader: string,
    destination_hikes: IDestinationHikes[],
    user: IUser,
    moderator: IUser,
}

export interface IDefaultResponse {
    description?: string
}

export interface IDeleteDestinationHike {
    deleted_destination_hike: number,
    status: string,
    description?: string,
}

export interface IRequest {
    hikes: IHike[]
    status: string
}

export interface IHikeResponse {
    hikes: IHike[]
    status: string
}

export const mockCities: ICity[] = [
    {
        id: 1,
        city_name: 'Категат (Хедебю)',
        status_id: 1,
        status: {id: 1, status_name: 'Существует'},
        description: 'Категат был одним из самых важных викингских городов, расположенных на острове Хейланд в Дании. Город был известен своими морскими торговыми маршрутами и фортификациями.',
        image_url: 'https://fiord.org/wp-content/uploads/2016/12/Hedeby-now.jpg'
    },
    {
        id: 2,
        city_name: 'Королевство Йорвик',
        status_id: 1,
        status: {id: 1, status_name: 'Существует'},
        description: 'Этот викингский город, известный как Йорк, был важным торговым и административным центром во времена викингов.\\nДублин (Ирландия): Викинги основали Дублин в 9 веке. Этот город был известен своей торговлей и культурным влиянием в регионе.',
        image_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/Kingdom_of_Jórvik.svg/400px-Kingdom_of_Jórvik.svg.png'
    },
    {
        id: 3,
        city_name: 'Новгород (Россия)',
        status_id: 1,
        status: {id: 1, status_name: 'Существует'},
        description: 'Викинги создали поселение в Новгороде, что сделало его важным торговым центром на востоке.',
        image_url: 'https://avatars.dzeninfra.ru/get-zen_doc/3229639/pub_5ec7ba99f66e3c72366a38ba_5ec9073987eb5a1725e2438d/scale_1200'
    },
    {
        id: 4,
        city_name: 'Лунд (Швеция)',
        status_id: 1,
        status: {id: 1, status_name: 'Существует'},
        description: 'Лунд был одним из первых викингских городов и центром вероисповедания викингов.',
        image_url: 'https://traveltimes.ru/wp-content/uploads/2021/10/Кафедральный-собор-Лунда-2048x1333.jpg'
    },
    {
        id: 5,
        city_name: 'Гриндавик (Исландия)',
        status_id: 1,
        status: {id: 1, status_name: 'Существует'},
        description: 'Этот город на Исландии служил базой для викингских мореплавателей и рыбаков.',
        image_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Iceland_adm_location_map.svg/500px-Iceland_adm_location_map.svg.png'
    },
    {
        id: 6,
        city_name: 'Висбю (Швеция)',
        status_id: 1,
        status: {id: 1, status_name: 'Существует'},
        description: 'Этот город на острове Готланд был важным торговым и административным центром викингов.',
        image_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Visby_13-.JPG/580px-Visby_13-.JPG'
    },
    {
        id: 7,
        city_name: 'Лимфьорд (Дания)',
        status_id: 1,
        status: {id: 1, status_name: 'Существует'},
        description: 'Лимфьорд был важным морским перекрестком и базой для викингских экспедиций.',
        image_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Jytland.Limfjord.jpg/240px-Jytland.Limfjord.jpg'
    },
    {
        id: 8,
        city_name: 'Рейкьявик (Исландия)',
        status_id: 1,
        status: {id: 1, status_name: 'Существует'},
        description: 'Викинги основали Рейкьявик, который со временем стал столицей Исландии.',
        image_url: 'https://traveller-eu.ru/sites/default/files/styles/main_img/public/evelyn-paris-WvPQYDd-3Ow-unsplash.webp?itok=PHKdX3SG'
    },
    {
        id: 9,
        city_name: 'Торшавн (Фарерские острова)',
        status_id: 1,
        status: {id: 1, status_name: 'Существует'},
        description: 'Этот город служил базой для викингов на Фарерских островах и был важным для контроля торговых путей в Северном Атлантическом регионе.',
        image_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Tórshavn_skansin_8.jpg/500px-Tórshavn_skansin_8.jpg'
    },
    {
        id: 10,
        city_name: 'Нормандия',
        status_id: 1,
        status: {id: 1, status_name: 'Существует'},
        description: 'Викинг Ролло основал герцогство Нормандия в IX веке после договора с франкским королём. Нормандия стала известной своими влияниями на культуру и историю.',
        image_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/Mont-Saint-Michel-2004.jpg/440px-Mont-Saint-Michel-2004.jpg'
    },
    {
        id: 11,
        city_name: 'Великая Зима',
        status_id: 1,
        status: {id: 1, status_name: 'Существует'},
        description: 'Это викингское поселение было обнаружено на территории современной России, недалеко от Волги.',
        image_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Venice_frozen_lagoon_1708.jpg/400px-Venice_frozen_lagoon_1708.jpg'
    },
]

export const defaultImage: string = `https://w.forfun.com/fetch/15/156edf6b7f00b207e365081fd2cd8186.jpeg`