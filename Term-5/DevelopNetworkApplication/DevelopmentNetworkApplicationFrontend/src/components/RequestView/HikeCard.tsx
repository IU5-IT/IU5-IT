import {FC, useEffect, useState} from 'react';
import {
    convertServerDateToInputFormat, DateFormat,
    deleteHike,
    emptyString, fetchHikeById,
    makeHike, moderatorUpdateStatus,
    updateHike
} from '../../store/reducers/ActionCreator';
import TableView from '../TableView/TableView.tsx';
import {IHike} from '../../models/models.ts';
import {useAppDispatch, useAppSelector} from "../../hooks/redux.ts";
import Cookies from "js-cookie";
import {useNavigate, useParams} from "react-router-dom";
import MyComponent from "../Popup/Popover.tsx";

interface HikeCardProps {
    setPage: (name: string, id: number) => void
}


const HikeCard: FC<HikeCardProps> = ({setPage}) => {
    const {hike_id} = useParams();
    const dispatch = useAppDispatch()
    const navigate = useNavigate();
    const {singleHike, success, error} = useAppSelector(state => state.hikeReducer)
    const [startHikeDate, setStartHikeDate] = useState('');
    const [endHikeDate, setEndHikeDate] = useState('');
    const [leader, setLeader] = useState('$');
    const [description, setDescription] = useState('$');
    const [hikeName, setHikeName] = useState('$');
    const role = Cookies.get('role')

    useEffect(() => {
        if (hike_id) {
            dispatch(fetchHikeById(hike_id, setPage))
        }
    }, []);

    const handleDeleteHike = (id: number) => {
        dispatch(deleteHike(id))
        navigate(-1);
    }

    const handlerApprove = () => {
        if (singleHike) {
            dispatch(moderatorUpdateStatus(singleHike.id, 3))
            navigate(-1);
        }
    }

    const handleDiscard = () => {
        if (singleHike) {
            dispatch(moderatorUpdateStatus(singleHike.id, 4))
            navigate(-1);
        }
    }

    const handleMakeRequest = () => {
        dispatch(makeHike())
        navigate(-1);
    }

    const handleSave = (id: number, hike: IHike) => {
        dispatch(
            updateHike(
                id,
                description == '$' ? hike.description : description,
                hikeName == '$' ? hike.hike_name : hikeName,
                startHikeDate == "" ? hike.date_start_hike : startHikeDate,
                endHikeDate == "" ? hike.date_end : endHikeDate,
                leader == '$' ? hike.leader : leader
            )
        )
    }

    return (
        <>
            {error != "" && <MyComponent isError={true} message={error}/>}
            {success != "" && <MyComponent isError={false} message={success}/>}

            <div className='mx-5 mb-5'>
                {
                    singleHike && <>
                        {/* ======================= ШАПКА =============================== */}

                        <div className="card">
                            <h3>Статус: {singleHike.status.status_name}</h3>
                            <div className="info">
                                <div className="author-info">
                                    <img src={singleHike.user.image_url} alt="Фото Автора" className="author-img"/>
                                    <div>
                                        <h4>{emptyString(singleHike.user.user_name, "Имя не задано")}</h4>
                                        <p>Профессия: {emptyString(singleHike.user.profession, 'Профессия не задана')}</p>
                                        <p>@{emptyString(singleHike.user.login, 'Логин на задан')}</p>
                                    </div>
                                </div>

                                <div className="dates-info">
                                    <p>
                                        Начало похода:
                                        <input
                                            type="date"
                                            className="form-control"
                                            value={startHikeDate || convertServerDateToInputFormat(singleHike.date_start_hike)}
                                            onChange={(e) => setStartHikeDate(e.target.value)}
                                            disabled={singleHike.status_id != 1}
                                        />
                                    </p>
                                    <p>
                                        Конец похода:
                                        <input
                                            type="date"
                                            className="form-control"
                                            value={endHikeDate || convertServerDateToInputFormat(singleHike.date_end)}
                                            onChange={(e) => setEndHikeDate(e.target.value)}
                                            disabled={singleHike.status_id != 1}
                                        />
                                    </p>
                                    <p>
                                        Лидер похода:
                                        <input
                                            type="text"
                                            className="form-control bg-black text-white"
                                            value={leader == "$" ? singleHike.leader : leader}
                                            onChange={(e) => setLeader(e.target.value)}
                                            disabled={singleHike.status_id != 1}
                                        />
                                    </p>
                                </div>

                            </div>
                            <div className="detail-info">
                                <label>Сформирована: {DateFormat(singleHike.date_start_of_processing)}</label>
                                <input
                                    type="text"
                                    className="form-control bg-black text-white"
                                    value={hikeName == "$" ? singleHike.hike_name : hikeName}
                                    onChange={(e) => setHikeName(e.target.value)}
                                    style={{marginBottom: '20px'}}
                                    disabled={singleHike.status_id != 1}
                                />
                                <textarea
                                    className="form-control description-text-info bg-black text-white"
                                    style={{height: "200px"}}
                                    value={description == "$" ? singleHike.description : description}
                                    onChange={(e) => setDescription(e.target.value)}
                                    disabled={singleHike.status_id != 1}
                                ></textarea>
                            </div>
                            <div style={{textAlign: 'right'}}>
                                {singleHike.status_id == 1 && <button
                                    type="button"
                                    className="btn btn-outline-light"
                                    onClick={() => handleSave(singleHike.id, singleHike)}
                                    style={{width: '150px', marginTop: '15px'}}
                                >
                                    Сохранить
                                </button>}
                            </div>
                        </div>

                        {/* ======================= ТАБЛИЦА ============================= */}

                        <TableView
                            setPage={setPage}
                            hikeID={hike_id ?? ''}
                            destHikes={singleHike.destination_hikes}
                            status={singleHike.status_id}
                        />

                        {/* ======================= КНОПКИ ============================= */}

                        <div className='delete-make' style={{display: 'flex', gap: '10px'}}>
                            {singleHike.status_id != 5 && (
                                <div style={{flex: 1}}>
                                    <button
                                        type="button"
                                        className="btn btn-outline-danger"
                                        onClick={() => handleDeleteHike(singleHike.id)}
                                    >
                                        Удалить
                                    </button>
                                </div>
                            )}

                            {singleHike.status_id == 1 && (
                                <div style={{flex: 1}}>
                                    <button
                                        type="button"
                                        className="btn btn-outline-light"
                                        onClick={handleMakeRequest}
                                    >
                                        Сформировать
                                    </button>
                                </div>
                            )}

                            {singleHike.status_id == 2 && role == '2' && (
                                <>
                                    <div style={{flex: 1}}>
                                        <button
                                            type="button"
                                            className="btn btn-outline-danger"
                                            onClick={() => handleDiscard()}
                                        >
                                            Отказать
                                        </button>
                                    </div>

                                    <div style={{flex: 1}}>
                                        <button
                                            type="button"
                                            className="btn btn-outline-light"
                                            onClick={handlerApprove}
                                        >
                                            Завершить
                                        </button>
                                    </div>
                                </>
                            )}
                        </div>
                    </>
                }
            </div>
        </>
    );
};

export default HikeCard;
