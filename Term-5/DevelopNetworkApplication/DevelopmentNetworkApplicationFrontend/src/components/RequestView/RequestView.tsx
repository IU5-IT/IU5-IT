import {FC, useEffect, useState} from "react";
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";
import {useAppDispatch, useAppSelector} from "../../hooks/redux.ts";
import {fetchHikes, fetchHikesFilter} from "../../store/reducers/ActionCreator.ts";
import MyComponent from "../Popup/Popover.tsx";
import {Link} from "react-router-dom";
import "./DatePickerStyles.css";
import "./RequestView.css";
import {Dropdown, Form, Button, Container, Row, Col} from "react-bootstrap";
import {format} from "date-fns";
import {useNavigate} from 'react-router-dom';
import Cookies from "js-cookie";
import {IHike} from "../../models/models.ts";

interface RequestViewProps {
    setPage: () => void;
}

const RequestView: FC<RequestViewProps> = ({setPage}) => {
    const navigate = useNavigate();
    const dispatch = useAppDispatch();
    const {hike, error, success} = useAppSelector((state) => state.hikeReducer);
    const {isAuth} = useAppSelector((state) => state.userReducer);
    const [startDate, setStartDate] = useState<Date | null>(null);
    const [endDate, setEndDate] = useState<Date | null>(null);
    const [selectedStatus, setSelectedStatus] = useState<string>('');
    const role = Cookies.get('role')
    const [filteredHikes, setFilteredHikes] = useState<IHike[] | null>(null);
    const [filteredByUsers, setFilteredUsers] = useState<IHike[] | null>(null);
    const [textValue, setTextValue] = useState<string>('');

    useEffect(() => {
        setPage();
        dispatch(fetchHikes());

        const handleFilterInterval = setInterval(() => {
            handleFilter();
        }, 3000);

        const cleanup = () => {
            clearInterval(handleFilterInterval);
        };

        window.addEventListener('beforeunload', cleanup);

        return () => {
            cleanup();
            window.removeEventListener('beforeunload', cleanup);
        };
    }, [startDate, endDate, selectedStatus]);

    const resetFilter = () => {
        setStartDate(null)
        setEndDate(null)
        setSelectedStatus('')
    }

    const handleFilter = () => {
        const formatDate = (date: Date | null | undefined): string | undefined => {
            if (!date) {
                return undefined;
            }
            const year = date.getFullYear();
            const month = (date.getMonth() + 1).toString().padStart(2, '0');
            const day = date.getDate().toString().padStart(2, '0');
            return `${year}-${month}-${day}`;
        };
        const formattedStartDate = formatDate(startDate);
        const formattedEndDate = formatDate(endDate);
        if (role == '2') {
            dispatch(fetchHikesFilter(formattedStartDate, formattedEndDate, `${selectedStatus}`));
        } else {
            localFilter(formattedStartDate, formattedEndDate)
        }
    };

    function formatDate2(inputDate: string): string {
        const date = new Date(inputDate);
        const year = date.getFullYear();
        const month = (date.getMonth() + 1).toString().padStart(2, '0')
        const day = date.getDate().toString().padStart(2, '0')
        const formattedDate = `${year}-${month}-${day}`
        return formattedDate
    }

    const localFilter = (startDateString: string | undefined, endDateString: string | undefined) => {

        function isDateInRange(date: string): boolean {
            const bdDateString = formatDate2(date)
            const bdDate = new Date(bdDateString)
            const start = startDateString ? new Date(startDateString) : new Date('0001-01-01')
            const end = endDateString ? new Date(endDateString) : new Date('2033-12-21')
            return (!startDate || bdDate >= start) && (!endDate || bdDate <= end)
        }

        if (hike) {
            const d = hike.hikes.filter(obj => isDateInRange(obj.date_start_of_processing))
            setFilteredHikes(d)
        }
    }

    const clickCell = (cellID: number) => {
        navigate(`/hikes/${cellID}`);
    }

    if (!isAuth) {
        return (
            <Link to="/login" className="btn btn-outline-danger">
                Требуется войти в систему
            </Link>
        );
    }

    const handleInputChange = () => {
        if (hike) {
            const d = hike.hikes.filter(obj => obj.user.login == textValue)
            setFilteredUsers(d.length == 0 ? null : d)
        }
    };

    return (
        <>
            <Container className="d-flex justify-content-center">
                <Row>
                    <Col>
                        <Form.Group controlId="exampleForm.ControlInput1">
                            <Form.Label>Фильтрация по пользователю</Form.Label>
                            <Form.Control
                                type="text"
                                placeholder="Введите текст"
                                value={textValue}
                                onChange={(e) => setTextValue(e.target.value)}
                                onKeyPress={(e) => {
                                    if (e.key === 'Enter') {
                                        handleInputChange();
                                    }
                                }}
                                style={{width: '100%'}}
                            />
                        </Form.Group>
                    </Col>
                </Row>
            </Container>

            {/* =================================== ALERTS ===========================================*/}

            {error !== "" && <MyComponent isError={true} message={error}/>}
            {success !== "" && <MyComponent isError={false} message={success}/>}

            {/* =================================== FILTERS ======================================*/}
            {role &&
                <div className="filter-section d-flex justify-content-end mb-3 pe-4">
                    <Dropdown>
                        <Dropdown.Toggle variant="success" id="dropdown-basic">
                            Фильтры
                        </Dropdown.Toggle>

                        <Dropdown.Menu className={'px-2'}>
                            <label>Дата создания с:</label>
                            <DatePicker
                                selected={startDate}
                                onChange={(date) => setStartDate(date)}
                                className="custom-datepicker"
                                popperPlacement="bottom-start"
                            />

                            <label>Дата окончания по:</label>
                            <DatePicker
                                selected={endDate}
                                onChange={(date) => setEndDate(date)}
                                className="custom-datepicker"
                                popperPlacement="bottom-start"
                            />

                            {role == '2' &&
                                <>
                                    <label>Статус похода:</label>
                                    <Form.Select
                                        className='my-2'
                                        value={selectedStatus || ""}
                                        onChange={(e) => setSelectedStatus(e.target.value)}
                                    >
                                        <option value="">Выберите статус</option>
                                        <option value="1">Черновик</option>
                                        <option value="2">Сформирован</option>
                                        <option value="3">Завершён</option>
                                        <option value="4">Отклонён</option>
                                    </Form.Select>
                                </>
                            }

                            <Button style={{width: '200px'}} className='mt-2' onClick={handleFilter}>Применить
                                фильтры</Button>
                            <Button variant="outline-danger" style={{width: '200px'}} className='mt-2'
                                    onClick={resetFilter}>Сбросить
                                фильтры</Button>

                        </Dropdown.Menu>
                    </Dropdown>
                </div>
            }

            {/* =================================== TABLE ADMIN =============================================*/}
            {hike &&
                <table className='table-hikes'>
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Название похода</th>
                        <th>Дата создания</th>
                        <th>Дата окончания похода</th>
                        <th>Дата начала процесса</th>
                        <th>Дата принятия</th>
                        <th>Дата начала похода</th>
                        <th>Автор</th>
                        {role == '2' &&
                            <th>Модератор</th>
                        }
                        <th>Статус</th>
                        <th>Лидер</th>
                    </tr>
                    </thead>
                    <tbody>
                    {filteredHikes && role == '0'
                        ? filteredHikes.map((hike) => (
                            <tr key={hike.id} onClick={() => clickCell(hike.id)}>
                                <td>{hike.id}</td>
                                <td>{hike.hike_name || 'Не задано'}</td>
                                <td>{checkData(hike.date_created)}</td>
                                <td>{checkData(hike.date_end)}</td>
                                <td>{checkData(hike.date_start_of_processing)}</td>
                                <td>{checkData(hike.date_approve)}</td>
                                <td>{checkData(hike.date_start_hike)}</td>
                                <td>{hike.user.user_name || 'Не задан'}</td>
                                <td>{hike.status.status_name}</td>
                                <td>{hike.leader || 'На задан'}</td>
                            </tr>
                        ))
                        : (filteredByUsers ? filteredByUsers : hike.hikes).map((hike) => (
                            <tr key={hike.id} onClick={() => clickCell(hike.id)}>
                                <td>{hike.id}</td>
                                <td>{hike.hike_name || 'Не задано'}</td>
                                <td>{checkData(hike.date_created)}</td>
                                <td>{checkData(hike.date_end)}</td>
                                <td>{checkData(hike.date_start_of_processing)}</td>
                                <td>{checkData(hike.date_approve)}</td>
                                <td>{checkData(hike.date_start_hike)}</td>
                                <td>{hike.user.user_name || 'Не задан'}</td>
                                {role == '2' &&
                                    <td>{hike.moderator.user_name || 'Не задан'}</td>
                                }
                                <td>{hike.status.status_name}</td>
                                <td>{hike.leader || 'На задан'}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            }
        </>
    );
};

export default RequestView;

function checkData(data: string): string {
    if (data == '0001-01-01T00:00:00Z') {
        return 'Дата не задана'
    }
    const formattedDate = (dateString: string) => {
        const date = new Date(dateString);
        return format(date, 'dd.MM.yyyy');
    };

    const formatted = formattedDate(data);
    return formatted
}
