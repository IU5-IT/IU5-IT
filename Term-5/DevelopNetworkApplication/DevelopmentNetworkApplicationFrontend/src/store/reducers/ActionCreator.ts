import {AppDispatch} from "../store.ts";
import axios from "axios";
import {
    IAuthResponse,
    ICityResponse,
    ICityWithBasket, IDefaultResponse,
    IDeleteDestinationHike, IHike,
    IHikeResponse, IRegisterResponse,
    IRequest,
    mockCities
} from "../../models/models.ts";
import Cookies from 'js-cookie';
import {citySlice} from "./CitySlice.ts"
import {hikeSlice} from "./HikeSlice.ts";
import {userSlice} from "./UserSlice.ts";


export const fetchCities = (searchValue?: string, makeLoading: boolean = true) => async (dispatch: AppDispatch) => {
    const accessToken = Cookies.get('jwtToken')
    dispatch(userSlice.actions.setAuthStatus(accessToken != null && accessToken != ""));
    const config = {
        method: "get",
        url: `/api/v3/cities`+ `?search=${searchValue ?? ''}`,
        headers: {
            Authorization: `Bearer ${accessToken ?? ''}`,
        },
    }

    try {
        if (makeLoading) {
            dispatch(citySlice.actions.citiesFetching())
        }
        const response = await axios<ICityWithBasket>(config);
        dispatch(citySlice.actions.citiesFetched([response.data.cities, response.data.basket_id]))
    } catch (e) {
        // dispatch(citySlice.actions.citiesFetchedError(`Пожалуйста, авторизуйтесь (`))
        dispatch(citySlice.actions.citiesFetched([filterMockData(searchValue), 0]))
    }
}

export const updateCityInfo = (
    id: number,
    cityName: string,
    description: string,
    statusId: string
) => async (dispatch: AppDispatch) => {
    const accessToken = Cookies.get('jwtToken')
    dispatch(userSlice.actions.setAuthStatus(accessToken != null && accessToken != ""));
    const config = {
        method: "put",
        url: `/api/v3/cities`,
        headers: {
            Authorization: `Bearer ${accessToken}`,
        },
        data: {
            id: id,
            city_name: cityName,
            description: description,
            status_id: parseInt(statusId, 10) ?? 1,
        },
    }

    try {
        dispatch(citySlice.actions.citiesFetching())
        const response = await axios<IDefaultResponse>(config);
        const error = response.data.description ?? ""
        const success = error == "" ? 'Данные обновленны' : ''
        dispatch(citySlice.actions.cityAddedIntoHike([error, success]))
        dispatch(fetchCities())
    } catch (e) {
        dispatch(citySlice.actions.citiesFetchedError(`Ошибка: ${e}`))
    }
}

export const updateCityImage = (cityId: number, file: File) => async (dispatch: AppDispatch) => {
    const accessToken = Cookies.get('jwtToken')
    dispatch(userSlice.actions.setAuthStatus(accessToken != null && accessToken != ""));
    const formData = new FormData();
    formData.append('file', file);
    formData.append('city_id', `${cityId}`);

    const config = {
        method: "put",
        url: `/api/v3/cities/upload-image`,
        headers: {
            Authorization: `Bearer ${accessToken}`,
        },
        data: formData,
    }

    try {
        dispatch(citySlice.actions.citiesFetching())
        const response = await axios<IDefaultResponse>(config);
        const error = response.data.description ?? ""
        const success = error == "" ? 'Фото обновленно' : ''
        dispatch(citySlice.actions.cityAddedIntoHike([error, success]))
        dispatch(fetchCities())
    } catch (e) {
        dispatch(citySlice.actions.citiesFetchedError(`Ошибка: ${e}`))
    }
}

export const deleteCity = (cityId: number) => async (dispatch: AppDispatch) => {
    const accessToken = Cookies.get('jwtToken')
    dispatch(userSlice.actions.setAuthStatus(accessToken != null && accessToken != ""));

    const config = {
        method: "delete",
        url: `/api/v3/cities`,
        headers: {
            Authorization: `Bearer ${accessToken}`,
        },
        data: {
            id: `${cityId}`
        },
    }

    try {
        dispatch(citySlice.actions.citiesFetching())
        const response = await axios<IDefaultResponse>(config);
        const error = response.data.description ?? ""
        const success = error == "" ? 'Город удалён' : ''
        dispatch(citySlice.actions.cityAddedIntoHike([error, success]))
        dispatch(fetchCities())
    } catch (e) {
        dispatch(citySlice.actions.citiesFetchedError(`Ошибка: ${e}`))
    }
}

export const addCityIntoHike = (cityId: number, serialNumber: number, cityName: string) => async (dispatch: AppDispatch) => {
    const accessToken = Cookies.get('jwtToken');

    const config = {
        method: "post",
        url: "/api/v3/cities/add-city-into-hike",
        headers: {
            Authorization: `Bearer ${accessToken}`,
        },
        data: {
            city_id: cityId,
            serial_number: serialNumber
        }
    }

    try {
        // dispatch(citySlice.actions.citiesFetching())
        const response = await axios(config);
        const errorText = response.data.description ?? ""
        const successText = errorText || `Город "${cityName}" добавлен`
        dispatch(citySlice.actions.cityAddedIntoHike([errorText, successText]));
        // eslint-disable-next-line @typescript-eslint/ban-ts-comment
        // @ts-ignore
        dispatch(fetchCities(null, false))
        setTimeout(() => {
            dispatch(citySlice.actions.cityAddedIntoHike(['', '']));
        }, 6000);
    } catch (e) {
        dispatch(citySlice.actions.citiesFetchedError(`${e}`))
    }
}

export const deleteHike = (id: number) => async (dispatch: AppDispatch) => {
    const accessToken = Cookies.get('jwtToken');

    const config = {
        method: "delete",
        url: "/api/v3/hikes",
        headers: {
            Authorization: `Bearer ${accessToken}`,
        },
        data: {
            id: id
        }
    }
    try {
        dispatch(hikeSlice.actions.hikesFetching())
        const response = await axios(config);
        const errorText = response.data.description ?? ""
        const successText = errorText || `Заявка удалена`
        dispatch(hikeSlice.actions.hikesUpdated([errorText, successText]));
        if (successText != "") {
            dispatch(fetchHikes())
        }
        setTimeout(() => {
            dispatch(hikeSlice.actions.hikesUpdated(['', '']));
        }, 6000);
    } catch (e) {
        dispatch(hikeSlice.actions.hikesDeleteError(`${e}`))
    }
}

export const makeHike = () => async (dispatch: AppDispatch) => {
    const accessToken = Cookies.get('jwtToken');

    const config = {
        method: "put",
        url: "/api/v3/hikes/update/status-for-user",
        headers: {
            Authorization: `Bearer ${accessToken}`,
        },
        data: {
            status_id: 2
        }
    }
    try {
        dispatch(hikeSlice.actions.hikesFetching())
        const response = await axios(config);
        const errorText = response.data.description ?? ""
        const successText = errorText || `Заявка создана`
        dispatch(hikeSlice.actions.hikesUpdated([errorText, successText]));
        if (successText != "") {
            dispatch(fetchHikes())
        }
        setTimeout(() => {
            dispatch(hikeSlice.actions.hikesUpdated(['', '']));
        }, 6000);
    } catch (e) {
        dispatch(hikeSlice.actions.hikesDeleteError(`${e}`))
    }
}

export const moderatorUpdateStatus = (hikeId: number, status: number) => async (dispatch: AppDispatch) => {
    const accessToken = Cookies.get('jwtToken');

    const config = {
        method: "put",
        url: "/api/v3/hikes/update/status-for-moderator",
        headers: {
            Authorization: `Bearer ${accessToken}`,
        },
        data: {
            status_id: status,
            hike_id: hikeId
        }
    }
    try {
        dispatch(hikeSlice.actions.hikesFetching())
        const response = await axios(config);
        const errorText = response.data.description ?? ""
        const successText = errorText || `Ответ принят`
        dispatch(hikeSlice.actions.hikesUpdated([errorText, successText]));
        if (successText != "") {
            dispatch(fetchHikes())
        }
        setTimeout(() => {
            dispatch(hikeSlice.actions.hikesUpdated(['', '']));
        }, 6000);
    } catch (e) {
        dispatch(hikeSlice.actions.hikesDeleteError(`${e}`))
    }
}

export const fetchHikes = () => async (dispatch: AppDispatch) => {
    const accessToken = Cookies.get('jwtToken');
    dispatch(userSlice.actions.setAuthStatus(accessToken != null && accessToken != ""));
    try {
        dispatch(hikeSlice.actions.hikesFetching())
        const response = await axios.get<IHikeResponse>(`/api/v3/hikes`, {
            headers: {
                Authorization: `Bearer ${accessToken}`
            }
        });

        const transformedResponse: IRequest = {
            hikes: response.data.hikes,
            status: response.data.status
        };
        dispatch(hikeSlice.actions.hikesFetched(transformedResponse))
    } catch (e) {
        dispatch(hikeSlice.actions.hikesFetchedError(`${e}`))
    }
}

export const fetchCurrentHike = () => async (dispatch: AppDispatch) => {
    interface ISingleHikeResponse {
        hikes: number,
    }

    const accessToken = Cookies.get('jwtToken');
    dispatch(userSlice.actions.setAuthStatus(accessToken != null && accessToken != ""));
    try {
        const response = await axios.get<ISingleHikeResponse>(`/api/v3/hikes/current`, {
            headers: {
                Authorization: `Bearer ${accessToken}`
            }
        });
        dispatch(citySlice.actions.setBasket(response.data.hikes))

    } catch (e) {
        dispatch(hikeSlice.actions.hikesFetchedError(`${e}`))
    }
}

export const fetchHikeById = (
    id: string,
    setPage: (name: string, id: number) => void
) => async (dispatch: AppDispatch) => {
    interface ISingleHikeResponse {
        hike: IHike,
    }

    const accessToken = Cookies.get('jwtToken');
    dispatch(userSlice.actions.setAuthStatus(accessToken != null && accessToken != ""));
    try {
        dispatch(hikeSlice.actions.hikesFetching())
        const response = await axios.get<ISingleHikeResponse>(`/api/v3/hikes/${id}`, {
            headers: {
                Authorization: `Bearer ${accessToken}`
            }
        });
        setPage(response.data.hike.hike_name, response.data.hike.id)
        dispatch(hikeSlice.actions.hikeFetched(response.data.hike))
    } catch (e) {
        dispatch(hikeSlice.actions.hikesFetchedError(`${e}`))
    }
}

export const fetchHikesFilter = (dateStart?: string, dateEnd?: string, status?: string) => async (dispatch: AppDispatch) => {
    const accessToken = Cookies.get('jwtToken');
    dispatch(userSlice.actions.setAuthStatus(accessToken != null && accessToken != ""));
    try {
        dispatch(hikeSlice.actions.hikesFetching())
        const queryParams: Record<string, string | undefined> = {};
        if (dateStart) {
            queryParams.start_date = dateStart;
        }
        if (dateEnd) {
            queryParams.end_date = dateEnd;
        }
        if (status) {
            queryParams.status_id = status;
        }
        const queryString = Object.keys(queryParams)
            .map((key) => `${key}=${encodeURIComponent(queryParams[key]!)}`)
            .join('&');
        const urlWithParams = `/api/v3/hikes${queryString ? `?${queryString}` : ''}`;
        const response = await axios.get<IHikeResponse>(urlWithParams, {
            headers: {
                Authorization: `Bearer ${accessToken}`
            }
        });

        const transformedResponse: IRequest = {
            hikes: response.data.hikes,
            status: response.data.status
        };
        // console.log(transformedResponse.hikes)
        dispatch(hikeSlice.actions.hikesFetched(transformedResponse))
    } catch (e) {
        dispatch(hikeSlice.actions.hikesFetchedError(`${e}`))
    }
}

export const deleteDestHikeById = (
    id: number,
    hike_id: string,
    setPage: (name: string, id: number) => void
) => async (dispatch: AppDispatch) => {
    const accessToken = Cookies.get('jwtToken');

    try {
        dispatch(hikeSlice.actions.hikesFetching())
        const response = await axios.delete<IDeleteDestinationHike>(`/api/v3/destination-hikes`, {
            headers: {
                Authorization: `Bearer ${accessToken}`
            },
            data: {
                id: id,
            },
        });
        dispatch(hikeSlice.actions.hikesDeleteSuccess(response.data))
        dispatch(fetchHikeById(hike_id, setPage))
    } catch (e) {
        dispatch(hikeSlice.actions.hikesFetchedError(`${e}`))
    }
}

export const updateHike = (
    id: number,
    description: string,
    hikeName: string,
    startDate: string,
    endDate: string,
    leader: string
) => async (dispatch: AppDispatch) => {
    const accessToken = Cookies.get('jwtToken');
    const config = {
        method: "put",
        url: "/api/v3/hikes",
        headers: {
            Authorization: `Bearer ${accessToken}`,
            ContentType: "application/json"
        },
        data: {
            description: description,
            hike_name: hikeName,
            date_start_hike: convertInputFormatToServerDate(startDate),
            date_end: convertInputFormatToServerDate(endDate),
            leader: leader,
            id: id,
        }
    };

    try {
        const response = await axios(config);
        const errorText = response.data.description ?? ""
        const successText = errorText || "Успешно обновленно"
        dispatch(hikeSlice.actions.hikesUpdated([errorText, successText]));
        setTimeout(() => {
            dispatch(hikeSlice.actions.hikesUpdated(['', '']));
        }, 5000);
    } catch (e) {
        dispatch(hikeSlice.actions.hikesFetchedError(`${e}`));
    }
}

export const fetchCity = (
    cityId: string,
    setPage: (name: string, id: number) => void
) => async (dispatch: AppDispatch) => {
    try {
        dispatch(citySlice.actions.citiesFetching())
        const response = await axios.get<ICityResponse>(`/api/v3/cities?city=${cityId}`)
        const city = response.data.city
        setPage(city.city_name ?? "Без названия", city.id)
        dispatch(citySlice.actions.cityFetched(city))
    } catch (e) {
        console.log(`Ошибка загрузки городов: ${e}`)
        const previewID = cityId !== undefined ? parseInt(cityId, 10) - 1 : 0;
        const mockCity = mockCities[previewID]
        setPage(mockCity.city_name ?? "Без названия", mockCity.id)
        dispatch(citySlice.actions.cityFetched(mockCity))
    }
}

export const createCity = (
    cityName?: string,
    description?: string,
    image?: File | null
) => async (dispatch: AppDispatch) => {
    const formData = new FormData();
    if (cityName) {
        formData.append('city_name', cityName);
    }
    if (description) {
        formData.append('description', description);
    }
    if (image) {
        formData.append('image_url', image);
    }
    formData.append('status_id', '1');
    const accessToken = Cookies.get('jwtToken');

    const config = {
        method: "post",
        url: "/api/v3/cities",
        headers: {
            Authorization: `Bearer ${accessToken}`,
            'Content-Type': 'multipart/form-data'
        },
        data: formData
    };

    try {
        dispatch(citySlice.actions.citiesFetching())
        const response = await axios(config);
        const errorText = response.data.description || ''
        const successText = errorText == '' ? "Город создан" : ''
        dispatch(citySlice.actions.cityAddedIntoHike([errorText, successText]))
        setTimeout(() => {
            dispatch(citySlice.actions.cityAddedIntoHike(['', '']));
        }, 6000)
    } catch (e) {
        dispatch(citySlice.actions.citiesFetchedError(`${e}`));
    }
}

export const registerSession = (userName: string, login: string, password: string) => async (dispatch: AppDispatch) => {
    const config = {
        method: "post",
        url: "/api/v3/users/sign_up",
        headers: {
            'Content-Type': 'application/json'
        },
        data: {
            'user_name': userName,
            login: login,
            password: password,
        }
    };

    try {
        dispatch(userSlice.actions.startProcess())
        const response = await axios<IRegisterResponse>(config);
        const errorText = response.data.login == '' ? 'Ошибка регистрации' : ''
        const successText = errorText || "Регистрация прошла успешно"
        dispatch(userSlice.actions.setStatuses([errorText, successText]))
        setTimeout(() => {
            dispatch(userSlice.actions.resetStatuses());
        }, 6000)
    } catch (e) {
        dispatch(userSlice.actions.setError(`${e}`));
    }
}

export const logoutSession = () => async (dispatch: AppDispatch) => {
    const accessToken = Cookies.get('jwtToken');

    const config = {
        method: "get",
        url: "/api/v3/users/logout",
        headers: {
            Authorization: `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    };
    try {
        dispatch(userSlice.actions.startProcess())
        const response = await axios(config);
        const errorText = response.data.login == '' ? 'Ошибка разлогина' : ''
        const successText = errorText || "Прощайте :("
        dispatch(userSlice.actions.setStatuses([errorText, successText]))
        if (errorText == '') {
            Cookies.remove('jwtToken');
            dispatch(userSlice.actions.setAuthStatus(false))
        }
        setTimeout(() => {
            dispatch(userSlice.actions.resetStatuses());
        }, 6000)
    } catch (e) {
        dispatch(userSlice.actions.setError(`${e}`));
    }
}

export const loginSession = (login: string, password: string) => async (dispatch: AppDispatch) => {
    const config = {
        method: "post",
        url: "/api/v3/users/login",
        headers: {
            'Content-Type': 'application/json'
        },
        data: {
            login: login,
            password: password,
        }
    };

    try {
        dispatch(userSlice.actions.startProcess())
        const response = await axios<IAuthResponse>(config);
        const errorText = response.data.description ?? ""
        const successText = errorText || "Добро пожаловать :)"
        dispatch(userSlice.actions.setStatuses([errorText, successText]));
        const jwtToken = response.data.access_token
        dispatch(userSlice.actions.setRole(response.data.role ?? ''))
        if (jwtToken) {
            Cookies.set('jwtToken', jwtToken);
            Cookies.set('role', response.data.role ?? '');
            dispatch(userSlice.actions.setAuthStatus(true));
            Cookies.set('userImage', response.data.userImage)
            Cookies.set('userName', response.data.userName)
        }
        setTimeout(() => {
            dispatch(userSlice.actions.resetStatuses());
        }, 6000);
    } catch (e) {
        dispatch(userSlice.actions.setError(`${e}`));
    }
}

// MARK: - Mock data

function filterMockData(searchValue?: string) {
    if (searchValue) {
        const filteredCities = mockCities.filter(city =>
            city.city_name?.toLowerCase().includes((searchValue ?? '').toLowerCase())
        );
        if (filteredCities.length === 0) {
            // eslint-disable-next-line @typescript-eslint/ban-ts-comment
            // @ts-ignore
            document.getElementById('search-text-field').value = ""
            alert("Данных нету")

        }
        return filteredCities
    }
    return mockCities
}

export function DateFormat(dateString: string) {
    if (dateString == "0001-01-01T00:00:00Z") {
        return "Дата не указана"
    }
    const date = new Date(dateString);
    return `${date.getDate()}-${(date.getMonth() + 1)
        .toString()
        .padStart(2, "0")}-${date.getFullYear()}`
}

export function emptyString(text: string, emptyText: string) {
    return text == "" ? emptyText : text
}

export const convertServerDateToInputFormat = (serverDate: string) => {
    const dateObject = new Date(serverDate);
    const year = dateObject.getFullYear();
    const month = (dateObject.getMonth() + 1).toString().padStart(2, '0');
    const day = dateObject.getDate().toString().padStart(2, '0');

    return `${year}-${month}-${day}`;
};

function convertInputFormatToServerDate(dateString: string): string {
    const dateRegex = /^4-2-2T2:2:2Z2:2/;
    if (dateRegex.test(dateString)) {
        return dateString;
    } else {
        const date = new Date(dateString);
        const isoDate = date.toISOString();
        return isoDate;
    }
}