import {FC, useEffect} from 'react';
import {useParams, useNavigate} from 'react-router-dom';
import './CityCard.css'
import {useAppDispatch, useAppSelector} from "../../hooks/redux.ts";
import {fetchCity} from "../../store/reducers/ActionCreator.ts";
import Cookies from "js-cookie";

interface CityDetailProps {
    setPage: (name: string, id: number) => void
}

const CityDetail: FC<CityDetailProps> = ({setPage}) => {
    const params = useParams();
    const dispatch = useAppDispatch()
    const {city, isLoading, error} = useAppSelector(state => state.cityReducer)
    const navigate = useNavigate();
    const role = Cookies.get('role')

    const handleDelete = () => {
        navigate('/cities');
        DeleteData()
            .then(() => {
                console.log(`City with ID ${city?.id} successfully deleted.`);
            })
            .catch(error => {
                console.error(`Failed to delete city with ID ${city?.id}: ${error}`);
                navigate('/cities');
            });
    }

    const DeleteData = async () => {
        try {
            const response = await fetch('http://localhost:7070/api/v3/cities/delete/' + city?.id, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                },
            });

            if (response.status === 200) {
                console.log('Город успешно удален');
                window.location.reload();
            } else {
                console.error('Произошла ошибка при удалении города');
            }

        } catch (error) {
            console.error('Произошла ошибка сети', error);
        }
    }

    const BackHandler = () => {
        navigate('/cities');
    }

    useEffect(() => {
        dispatch(fetchCity(`${params.id}`, setPage))
    }, [params.id]);

    return (
        <>
            {isLoading && <h1> Загрузка данных .... </h1>}
            {error && <h1>Ошибка {error} </h1>}
            {<div className="city-card-body">
                <div className="card-container">
                    <span className="pro">Город</span>
                    <img
                        className="round"
                        src={city?.image_url}
                        alt={city?.city_name}
                    />
                    <h3>{city?.city_name}</h3>
                    <h6>Статус: {city?.status.status_name}</h6>
                    <p>{city?.description}</p>
                    {role == '2' &&
                        <img
                            className="delete-button"
                            src="/deleteTrash.png"
                            alt="Delete"
                            onClick={handleDelete}
                        />
                    }
                    <div className="buttons">
                        <button className="primary" onClick={BackHandler}>Назад</button>
                    </div>
                </div>
            </div>}
        </>
    );
};

export default CityDetail;
